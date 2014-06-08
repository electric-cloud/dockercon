</div>

<div id="Footer">

<div id="PoweredBy">&nbspElectric Cloud: <a href="www.electric-cloud.com">www.electric-cloud.com</a>
</div>

<div id="Banner"><c:if test="${sessionScope.accountBean != null }">
	<c:if test="${sessionScope.accountBean.authenticated}">
		<c:if test="${sessionScope.accountBean.account.bannerOption}">
          ${sessionScope.accountBean.account.bannerName}
        </c:if>
	</c:if>
</c:if></div>

</div>

</body>
</html>
