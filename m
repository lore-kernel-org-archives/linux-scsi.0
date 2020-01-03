Return-Path: <SRS0=yTIb=2Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61E81C32770
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jan 2020 02:59:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39D6522314
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jan 2020 02:59:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PYxeuGH4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbgACC7s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jan 2020 21:59:48 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33388 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgACC7r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jan 2020 21:59:47 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0032xAnq081778;
        Fri, 3 Jan 2020 02:59:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=sLOTaRz6FWrAwppWWWtqXcyocWP/mMZ56iPUA9V8U9o=;
 b=PYxeuGH4pHDdrVJ9+PL5c+3B0zBCS2LxgpDbMuquqeW1WXQbJVuw+QiEexDOKu1QsdT3
 iqdOlpXIzmDo7NEeTpub2YNZPwYQbPNMFwhnUhUaPt8+3j8Xj8CUry3vX1fHGfGZoOcd
 S3MpWuxWNe6Ya3iN0ndCvcflCEAIwhd/SFhnHHOyrlAqx5NG2BSf3PjBfcAv/E6j4g7D
 56L1hXt2sBVlAy01b2volKicWU+hRy2SduPRCHcIXKRv07gws/IAkrTImEb1CPp47QFf
 SA8Nsgt90d8AcHRa6IIN0QSQkN+DfZhB0ZKasR9sFyBwTSAcgXvAr/UcossRiVWu1TL6 mg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2x5y0ptan2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 02:59:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0032xAUw057548;
        Fri, 3 Jan 2020 02:59:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2x8guuq2tc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 02:59:26 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0032xNg6021971;
        Fri, 3 Jan 2020 02:59:23 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Jan 2020 18:59:22 -0800
To:     Nishad Kamdar <nishadkamdar@gmail.com>
Cc:     Hannes Reinecke <hare@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] scsi: Use the correct style for SPDX License Identifier
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <cover.1577511720.git.nishadkamdar@gmail.com>
Date:   Thu, 02 Jan 2020 21:59:19 -0500
In-Reply-To: <cover.1577511720.git.nishadkamdar@gmail.com> (Nishad Kamdar's
        message of "Sat, 28 Dec 2019 11:24:20 +0530")
Message-ID: <yq15zht5jp4.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9488 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=745
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001030026
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9488 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=808 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001030027
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nishad,

> This patch corrects the SPDX License Identifier style in the scsi
> driver related files.

Applied to 5.6/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
