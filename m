Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D749C4708F
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 21:41:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EAFB61005
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 21:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbhEaVnh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 May 2021 17:43:37 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:20528 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232207AbhEaVnc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 May 2021 17:43:32 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210531214149epoutp011293771432316101dac30f78200c047b~ERLT0BqsU0154801548epoutp01D
        for <linux-scsi@vger.kernel.org>; Mon, 31 May 2021 21:41:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210531214149epoutp011293771432316101dac30f78200c047b~ERLT0BqsU0154801548epoutp01D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1622497309;
        bh=mJNhGMXoemISE1Q3mRLGVx7FRyggBn1pt7nEDZk9h7k=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=iMt9YJo0dafDgywd+56VDiWpu0tzcs6TTQNkqCtfMsb4pPEgFjz1w2o0y2k09BNwk
         heb03rIX2PLwgMLeDGrH8WFqSNEhFuMW2jooGYMTkUHQmY3YzAyLmwnRORO33QBF0E
         nnJI7PbfzycQXvuWFr2XhRGcPhdMmd2ERD/1bQxc=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20210531214149epcas5p14318c4ad846c9cc0d65a0ee76ee60e2a~ERLTaf7f51426014260epcas5p1m;
        Mon, 31 May 2021 21:41:49 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E9.88.09697.D1855B06; Tue,  1 Jun 2021 06:41:49 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20210531163631epcas5p381e4290b2d395cec64929d316b92ca6d~ENAvxk2_71174411744epcas5p3B;
        Mon, 31 May 2021 16:36:31 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210531163631epsmtrp1b62bd008d943c1ba71165bfd78101f1d~ENAvwwe_63153631536epsmtrp14;
        Mon, 31 May 2021 16:36:31 +0000 (GMT)
X-AuditID: b6c32a4a-64fff700000025e1-4c-60b5581d3462
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        4F.6D.08637.F8015B06; Tue,  1 Jun 2021 01:36:31 +0900 (KST)
Received: from alimakhtar02 (unknown [107.122.12.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210531163630epsmtip22d023c400c474d32945598e42bbb962a~ENAuQ7eUG2866628666epsmtip2M;
        Mon, 31 May 2021 16:36:29 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Bean Huo'" <huobean@gmail.com>, <avri.altman@wdc.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <bvanassche@acm.org>,
        <tomas.winkler@intel.com>, <cang@codeaurora.org>
Cc:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: <20210531163122.451375-1-huobean@gmail.com>
Subject: RE: [PATCH] scsi: ufs: Fix a kernel-doc related formatting issue
Date:   Mon, 31 May 2021 22:06:28 +0530
Message-ID: <049f01d7563b$1ca20b80$55e62280$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJjv1EpM/axuzSk65Sq4q2WIIiGrQKDUQ/EqdDcuhA=
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEKsWRmVeSWpSXmKPExsWy7bCmhq5sxNYEg30vuC1e/rzKZnHwYSeL
        xbQPP5ktPq1fxmox52wDk8WiG9uYLC7vmsNm0X19B5vF8uP/mCw+9NQ5cHlcvuLtcbmvl8lj
        56y77B6L97xk8piw6ACjx/f1HWweH5/eYvH4vEnOo/1AN1MAZxSXTUpqTmZZapG+XQJXRuO8
        R2wFc9grTm64yd7A2M7WxcjJISFgInF4eRNjFyMXh5DAbkaJZx+mMkE4nxglutbdhcp8Y5Q4
        /XYbK0zLgutf2SASexklXuxZCtXyklHieWs/WBWbgK7EjsVtYFUiAhcZJWZdXgGWYBZwkDj5
        YAcTiM0pYCGx+e8xsEuEBTwluvvegMVZBFQlnk0/yg5i8wpYSrz63MsCYQtKnJz5hAVijrzE
        9rdzmCFOUpD4+XQZ2HwRASuJrTtusUHUiEsc/dnDDHKEhMAJDonbk89B/eAiMfPiKyYIW1ji
        1fEt7BC2lMTL/jYgmwPIzpbo2WUMEa6RWDrvGAuEbS9x4MocFpASZgFNifW79CHCshJTT61j
        gljLJ9H7+wnUdF6JHfNgbFWJ5ndXocZIS0zs7madwKg0C8lns5B8NgvJB7MQti1gZFnFKJla
        UJybnlpsWmCUl1quV5yYW1yal66XnJ+7iRGczLS8djA+fPBB7xAjEwfjIUYJDmYlEd4zFRsT
        hHhTEiurUovy44tKc1KLDzFKc7AoifOueDg5QUggPbEkNTs1tSC1CCbLxMEp1cC0/+XfOa+n
        5N0RnKN76Uyj/4PJ1wXnmfr+dbf+0Zkx/fKMB+9nPUmdlLxaJclh3/JwV0OG7ZuXcRw3Vzpz
        ZuG9CYu9dr916lPYxmToyMCreX7pdsZX/ZlcH37u5Leev/k7y0+P+0leP13zC57G2ZXNWqr8
        qnxacLpl1buJ6re3lkxd+u/AO1UBvWvNu89M+WHNn13fW37LxCBl7k/FH19lo5m3Je1mTbcq
        L9sV+n3Vn3usj/60zj6d03dx9enJLau2TfoopSPN8bmkZb5v59cVj38Xx91czbk34p1ras/d
        ySdqVr3SCFG/p8F15ucttaUPkzfOZ/pR7vSqtvxFZ9x26f+Hbb/YBBgq5/847F64+4ASS3FG
        oqEWc1FxIgCVu+Xs1QMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsWy7bCSvG6/wNYEg8M3lCxe/rzKZnHwYSeL
        xbQPP5ktPq1fxmox52wDk8WiG9uYLC7vmsNm0X19B5vF8uP/mCw+9NQ5cHlcvuLtcbmvl8lj
        56y77B6L97xk8piw6ACjx/f1HWweH5/eYvH4vEnOo/1AN1MAZxSXTUpqTmZZapG+XQJXRuO8
        R2wFc9grTm64yd7A2M7WxcjJISFgIrHg+lcgm4tDSGA3o8S5ydeZIRLSEtc3TmCHsIUlVv57
        zg5R9JxR4sP9E6wgCTYBXYkdi9vAukUEbjNKtJzeCFTFwcEs4CSx52YSREMno8TXxwfBpnIK
        WEhs/nsMbLWwgKdEd98bJhCbRUBV4tn0o2DbeAUsJV597mWBsAUlTs58wgIxU0+ibSMjSJhZ
        QF5i+9s5UIcqSPx8ugzsHhEBK4mtO26xQdSISxz92cM8gVF4FpJJsxAmzUIyaRaSjgWMLKsY
        JVMLinPTc4sNCwzzUsv1ihNzi0vz0vWS83M3MYLjUUtzB+P2VR/0DjEycTAeYpTgYFYS4T1T
        sTFBiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+FrpPxQgLpiSWp2ampBalFMFkmDk6pBqamfQ4f
        znl7qTEbJUxxeLMveprvjydfb52tfbq89kxIxHsmXdY2ro9fP+zWOx+/JTG28ZxbVNIEb9fl
        khsjp5c+nO19+YPMc1MNbu7KSQc3tu3sfnPfpzFpp/3iPN9S7b03z05hUmuXuRv9+yfTj5ky
        XYF/WaXMaxwDOb/W8U53ZVme/my3IH/owYoAxqyXcQrr9rBfnLr82VG3XQb/lpp8PT/jevjl
        V0qKmqVuHq1H3m1SOs518uWOtwuid7/zn/f8ZfJqSze7TRzcakcOpjEp13w4fyRKszpONPVI
        8adPdl84S+J6JhjP0N3yT/l09pXZPi5z4w9/vWLTk3L037UVL2T0mlU2MU6LP7l1TY6LEktx
        RqKhFnNRcSIAzS0F5DYDAAA=
X-CMS-MailID: 20210531163631epcas5p381e4290b2d395cec64929d316b92ca6d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CMS-RootMailID: 20210531163136epcas5p33bc53d90af17333be4b2805d7ad3155e
References: <CGME20210531163136epcas5p33bc53d90af17333be4b2805d7ad3155e@epcas5p3.samsung.com>
        <20210531163122.451375-1-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bean,

> -----Original Message-----
> From: Bean Huo <huobean@gmail.com>
> Sent: 31 May 2021 22:01
> To: alim.akhtar@samsung.com; avri.altman@wdc.com; jejb@linux.ibm.com;
> martin.petersen@oracle.com; beanhuo@micron.com;
> bvanassche@acm.org; tomas.winkler@intel.com; cang@codeaurora.org
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] scsi: ufs: Fix a kernel-doc related formatting issue
> 
> From: Bean Huo <beanhuo@micron.com>
> 
> Fix the following W=1 kernel build warning:
> 
> drivers/scsi/ufs/ufshcd.c:9773: warning: This comment starts with '/**',
but
> isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

>  drivers/scsi/ufs/ufshcd.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
.
.
.
> --
> 2.25.1


