package org.mybatis.jpetstore.web.actions;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.servlet.http.HttpSession;

import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.RedirectResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.SessionScope;
import net.sourceforge.stripes.integration.spring.SpringBean;
import net.sourceforge.stripes.validation.Validate;

import org.mybatis.jpetstore.domain.Account;
import org.mybatis.jpetstore.domain.Product;
import org.mybatis.jpetstore.service.AccountService;
import org.mybatis.jpetstore.service.CatalogService;

@SessionScope
public class AccountActionBean extends AbstractActionBean {

  private static final long serialVersionUID = 5499663666155758178L;

  private static final String NEW_ACCOUNT = "/WEB-INF/jsp/account/NewAccountForm.jsp";
  private static final String EDIT_ACCOUNT = "/WEB-INF/jsp/account/EditAccountForm.jsp";
  private static final String SIGNON = "/WEB-INF/jsp/account/SignonForm.jsp";

  private static final List<String> LANGUAGE_LIST;
  private static final List<String> CATEGORY_LIST;

  @SpringBean
  private transient AccountService accountService;
  @SpringBean
  private transient CatalogService catalogService;

  private Account account = new Account();
  private List<Product> myList;
  private boolean authenticated;

  static {
    List<String> langList = new ArrayList<String>();
    langList.add("english");
    langList.add("japanese");
    LANGUAGE_LIST = Collections.unmodifiableList(langList);

    List<String> catList = new ArrayList<String>();
    catList.add("FISH");
    catList.add("DOGS");
    catList.add("REPTILES");
    catList.add("CATS");
    catList.add("BIRDS");
    CATEGORY_LIST = Collections.unmodifiableList(catList);
  }

  public Account getAccount() {
    return this.account;
  }
  
  public String getUsername() {
    return account.getUsername();
  }

  @Validate(required=true, on={"signon", "newAccount", "editAccount"})
  public void setUsername(String username) {
    account.setUsername(username);
  }

  public String getPassword() {
    return account.getPassword();
  }

  @Validate(required=true, on={"signon", "newAccount", "editAccount"})
  public void setPassword(String password) {
    account.setPassword(password);
  }

  public List<Product> getMyList() {
    return myList;
  }

  public void setMyList(List<Product> myList) {
    this.myList = myList;
  }

  public List<String> getLanguages() {
    return LANGUAGE_LIST;
  }

  public List<String> getCategories() {
    return CATEGORY_LIST;
  }

  public Resolution newAccountForm() {
    return new ForwardResolution(NEW_ACCOUNT);
  }
  
  public Resolution newAccount() {
    accountService.insertAccount(account);
    account = accountService.getAccount(account.getUsername());
    myList = catalogService.getProductListByCategory(account.getFavouriteCategoryId());
    authenticated = true;
    return new RedirectResolution(CatalogActionBean.class);
  }

  public Resolution editAccountForm() {
    return new ForwardResolution(EDIT_ACCOUNT);
  }

  public Resolution editAccount() {
    accountService.updateAccount(account);
    account = accountService.getAccount(account.getUsername());
    myList = catalogService.getProductListByCategory(account.getFavouriteCategoryId());
    return new RedirectResolution(CatalogActionBean.class);
  }
  
  @DefaultHandler
  public Resolution signonForm() {
    return new ForwardResolution(SIGNON);
  }

  public Resolution signon() {

    account = accountService.getAccount(getUsername(), getPassword());
   
    if (account == null) {
      String value = "Invalid username or password.  Signon failed.";
      setMessage(value);
      clear();
      return new ForwardResolution(SIGNON);
    } else {
      account.setPassword(null);
      myList = catalogService.getProductListByCategory(account.getFavouriteCategoryId());
      authenticated = true;
      HttpSession s = context.getRequest().getSession();
      // this bean is already registered as /actions/Account.action
      s.setAttribute("accountBean", this);
      return new RedirectResolution(CatalogActionBean.class);
    }
  }

  public Resolution signoff() {
    context.getRequest().getSession().invalidate();
    clear();
    return new RedirectResolution(CatalogActionBean.class);
  }

  public boolean isAuthenticated() {
    return authenticated && account != null && account.getUsername() != null;
  }

  public void clear() {
    account = new Account();
    myList = null;
    authenticated = false;
  }

}
