Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7974C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 01:24:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58AED2312A
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 01:24:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbhAGBYf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jan 2021 20:24:35 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:62644 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbhAGBYf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2021 20:24:35 -0500
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210107012352epoutp0453d0ed4b7d81b81826fdbf683ea28047~Xzqyqt41y1650516505epoutp04b
        for <linux-scsi@vger.kernel.org>; Thu,  7 Jan 2021 01:23:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210107012352epoutp0453d0ed4b7d81b81826fdbf683ea28047~Xzqyqt41y1650516505epoutp04b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1609982632;
        bh=lZQr/BNAVc2zPCCDVpvZSEEd7+/C8Ub6qxHC3FLZMSk=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=KOycJRT5KoKCflTgowFTA61pjUQTgnllsrsbzGAnoOGNKJYwLtLgwip57iZMHt0ef
         SiXuy73wQ/SYtTlCAdVpwXw44CjXrDMwg4DiLom8qy+CvUkSlT2oB75A9pf31yCUQq
         hyYH2LupfKodP3V/laTRUAyhEkgEesS1/eniZ9kg=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20210107012352epcas5p18d38c0faac64c151f2d10b93260fa91e~XzqydAx482216122161epcas5p1m;
        Thu,  7 Jan 2021 01:23:52 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        5E.1D.33964.8A266FF5; Thu,  7 Jan 2021 10:23:52 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20210107012352epcas5p28217298cc4e6cf7787aff1472d618726~XzqyGkTCA1106611066epcas5p24;
        Thu,  7 Jan 2021 01:23:52 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210107012352epsmtrp24726259c6b740963d579e384c7278e7c~XzqyFzS8Q3004530045epsmtrp2D;
        Thu,  7 Jan 2021 01:23:52 +0000 (GMT)
X-AuditID: b6c32a4b-eb7ff700000184ac-83-5ff662a8d1c1
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        2C.9F.08745.7A266FF5; Thu,  7 Jan 2021 10:23:52 +0900 (KST)
Received: from alimakhtar02 (unknown [107.122.12.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210107012351epsmtip1c0debdb305ba4238bed6831a3d1ebfd0~XzqxEcmI82381423814epsmtip1Q;
        Thu,  7 Jan 2021 01:23:50 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Randy Dunlap'" <rdunlap@infradead.org>,
        <linux-kernel@vger.kernel.org>
Cc:     "'Avri Altman'" <avri.altman@wdc.com>,
        <linux-scsi@vger.kernel.org>,
        "'James E.J. Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K. Petersen'" <martin.petersen@oracle.com>
In-Reply-To: <20210106205554.18082-1-rdunlap@infradead.org>
Subject: RE: [PATCH -next] scsi: ufs: fix all Kconfig help text indentation
Date:   Thu, 7 Jan 2021 06:53:49 +0530
Message-ID: <052001d6e493$c1fb0fb0$45f12f10$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQG3tqYHXragKCNirWnPT3uZrpIbEgIXg0mOqkj9U9A=
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsWy7bCmpu6KpG/xBp1bZC1e/rzKZrHoxjYm
        i8u75rBZdF/fwWax/Pg/Jou3d6azOLB5bF6h5TFh0QFGj49Pb7F4fN4k59F+oJspgDWKyyYl
        NSezLLVI3y6BK6P7snpBO3vFrj0zWRsYG9m6GDk5JARMJA7d+cjUxcjFISSwm1Hi6r11bBDO
        J0aJQ2sus0M4nxklPs9YzwzTsuLHHKiWXUCJJXNYIZyXjBJT3k8CG8wmoCuxY3EbmC0i4CPx
        +vQxRpAiZoH1jBJHV/9lB0lwClhLTNrxA6xIWMBb4sLT42BxFgEViR371zKC2LwClhIftyxj
        gbAFJU7OfAJmMwvIS2x/OwfqJAWJn0+XsUIss5LonDGBFaJGXOLozx6oml4OiUMzzSBsF4kN
        15qh4sISr45vYYewpSQ+v9sLdA8HkJ0t0bPLGCJcI7F03jEWCNte4sCVOSwgJcwCmhLrd+lD
        bOKT6P39hAmik1eio00IolpVovndVahOaYmJ3d2sELaHxPmzL5kmMCrOQvLXLCR/zUJy/yyE
        ZQsYWVYxSqYWFOempxabFhjnpZbrFSfmFpfmpesl5+duYgQnHi3vHYyPHnzQO8TIxMF4iFGC
        g1lJhNfi2Jd4Id6UxMqq1KL8+KLSnNTiQ4zSHCxK4rw7DB7ECwmkJ5akZqemFqQWwWSZODil
        GpisM7bIBjIqehvm6v7uYL12RDAoID3r8d8FvjMK5011lbmsecHiW8LDqkXrFRXP2u7a0DxT
        tblWPyHl/Z1z71Qk2SayS4ZIutxyfWWu3Olsy/ah8Jil5/9bhQcUQxYZ7XNLD1M7P8s3L7Nq
        wZ8z/6WyzyspvFHd5/Jsj2XLq3ds+x983uP0MPmMCoNmzdcOd/M226U/TwbtdpDOWht6oacs
        scDX5fac1NK6tNc/jVqWz/v9k+dAcaRA7oHD3/L7ej6LzNyy1CgiyM5gzntv3/Za2Vsh1kH3
        1u6IE9t3YT7DhJ35Gdfjd5sEx9/rySzI0Nx+mNNh+oU91gFzn/2wisv1PdK4smrfy9scvdM1
        uJRYijMSDbWYi4oTAbOxeeyrAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRmVeSWpSXmKPExsWy7bCSnO6KpG/xBrveMlm8/HmVzWLRjW1M
        Fpd3zWGz6L6+g81i+fF/TBZv70xncWDz2LxCy2PCogOMHh+f3mLx+LxJzqP9QDdTAGsUl01K
        ak5mWWqRvl0CV0b3ZfWCdvaKXXtmsjYwNrJ1MXJySAiYSKz4MYepi5GLQ0hgB6PErva/UAlp
        iesbJ7BD2MISK/89B7OFBJ4zSjyblAJiswnoSuxY3AZWLyLgJ7H73BE2kEHMAhsZJabNuMYO
        MbWHUeLJzUdg3ZwC1hKTdvwA6xAW8Ja48PQ4WJxFQEVix/61jCA2r4ClxMcty1ggbEGJkzOf
        ANkcQFP1JNo2gpUwC8hLbH87hxniOAWJn0+XsUIcYSXROWMCK0SNuMTRnz3MExiFZyGZNAth
        0iwkk2Yh6VjAyLKKUTK1oDg3PbfYsMAoL7Vcrzgxt7g0L10vOT93EyM4frS0djDuWfVB7xAj
        EwfjIUYJDmYlEV6LY1/ihXhTEiurUovy44tKc1KLDzFKc7AoifNe6DoZLySQnliSmp2aWpBa
        BJNl4uCUamCS/r8tf7J5PctVs9uFQs0azQ+1t/EeWc+pz8E3nduAtfFPR+DTud4nMu51SL7u
        6Ju6INHy178Xb/jXeNuevrXpzKo7dtVrxHbvWPnCNuzSmokxR9ydZwcHmZee/+xxjHXRRo9w
        IdeurI2cvrNvnJo5ZXqIU3Hf9NfeYndf17MXvSwV7snQSlybOiex+LZX4NVPIpfXZ31kmFOk
        9Gax0cun+QwBrbI7Tq2+p/JT1+9ia9B7FfkFE9uLywxmyb4I/CbBXHS39XHJ1rMTCrJDpSI3
        bTjOsKz96ur3SrZ3/89OkDqWmyGnb8/pM61etfLlvf7ZVz8Lln+olLX+pHXypdedqXc7VIyl
        FZJFDMIf1V9QYinOSDTUYi4qTgQA/aTJgg4DAAA=
X-CMS-MailID: 20210107012352epcas5p28217298cc4e6cf7787aff1472d618726
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20210106205857epcas5p31c8d9aee87cb459ef431b8e8c965bdfe
References: <CGME20210106205857epcas5p31c8d9aee87cb459ef431b8e8c965bdfe@epcas5p3.samsung.com>
        <20210106205554.18082-1-rdunlap@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Randy,

> -----Original Message-----
> From: Randy Dunlap <rdunlap@infradead.org>
> Sent: 07 January 2021 02:26
> To: linux-kernel@vger.kernel.org
> Cc: Randy Dunlap <rdunlap@infradead.org>; Alim Akhtar
> <alim.akhtar@samsung.com>; Avri Altman <avri.altman@wdc.com>; linux-
> scsi@vger.kernel.org; James E.J. Bottomley <jejb@linux.ibm.com>; Martin K.
> Petersen <martin.petersen@oracle.com>
> Subject: [PATCH -next] scsi: ufs: fix all Kconfig help text indentation
> 
> Use consistent and expected indentation for all Kconfig text.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: linux-scsi@vger.kernel.org
> Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> ---

Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>


