Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBBCBC56202
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 03:37:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5598522267
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 03:37:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="loglzgex"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbgKTDhA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Nov 2020 22:37:00 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:38412 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbgKTDg7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2020 22:36:59 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AK3OxAh096019;
        Fri, 20 Nov 2020 03:31:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=67dTBmUGckDFPhVupJWT4pclAbMGc1TiRi9QJ/ol3GY=;
 b=loglzgexwG8sza19oTC6ypZun0gEUI92sSd4Nap91uYDY9Ciok9XD2e+5XJElwgy4Ysu
 ncKaifhY78nYxF9aghYQcMoKo2eeO86BqxnrRXpcD9o/JBo2r8y3t87GvflMgpMdz7Xa
 EwNpuz1RYA4Ief0wRTGMZcGCBh9BXJXwZsw6j2I4RXpvfbjtjStOvsy/8HmWgVjVZDTc
 vCbjnUT5k4X7gOjvCG6JB3BxfwWeupabn7bUYQipitbmfkbYEWALbMhEHYNFJFafY13e
 8RiRlAn9tVNSbwBDM8fGWKjcvN0vSYNBfH233rQMmkxY2W+FoeLJydDdOwjVWd8t0lJe 2g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34t76m8qxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 20 Nov 2020 03:31:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AK3OeZP029073;
        Fri, 20 Nov 2020 03:31:50 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 34ts60wh8v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 03:31:50 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AK3VmYF011032;
        Fri, 20 Nov 2020 03:31:48 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Nov 2020 19:31:48 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, Lee Jones <lee.jones@linaro.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/1] scsi: pm8001: pm8001_hwi: Remove unused variable 'value'
Date:   Thu, 19 Nov 2020 22:31:41 -0500
Message-Id: <160584262848.7157.434419881287888181.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201116104119.816527-1-lee.jones@linaro.org>
References: <20201116104119.816527-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=974
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011200023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 mlxlogscore=988
 malwarescore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011200023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 16 Nov 2020 10:41:19 +0000, Lee Jones wrote:

> Hasn't been used since 2009.
> 
> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/scsi/pm8001/pm8001_hwi.c: In function ‘mpi_set_phys_g3_with_ssc’:
>  drivers/scsi/pm8001/pm8001_hwi.c:415:6: warning: variable ‘value’ set but not used [-Wunused-but-set-variable]

Applied to 5.11/scsi-queue, thanks!

[1/1] scsi: pm8001: Remove unused variable 'value'
      https://git.kernel.org/mkp/scsi/c/a364a3ea32da

-- 
Martin K. Petersen	Oracle Linux Engineering
