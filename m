Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9B6AC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 04:54:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2CF023A58
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 04:54:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbgLHExu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 23:53:50 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40304 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727193AbgLHExu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 23:53:50 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B84ocIt134327;
        Tue, 8 Dec 2020 04:53:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=q6vcNK7EUL0+jkb9MM0W0hXlcVsoj2SoAzgXmE5ZB+w=;
 b=CPBtcTTG8Tp+bPm/QCYxn2FGCTxA5mp6XZIS72vQfJJ6EJZyWivM3pKsaWprA0ZYhaJp
 3+dVHOWOS4mMgIRF67k3Z0hn47esJOYRkvKZ17guhSOV7a7HyOJEbblIaKNBvDLVML89
 SZgSmkKpmSVT8foU1Ie+DDcFyYdlLy86fNuGECW7LL2K+5afDeE49+4F14N2I+NwVEwY
 AQf/2DfJ3/wsHrzlL3DHKJOdL1SVKD1pmkZKYHUDZOrHv071Ks0kFC9RTXjszr8BiQbp
 CybV/Z8PtHtKvQTW4u+6hC4yv9jEw9mcfMeJpRA/nKTG71pt5gqxj0f/8R7Vq6k42KRG 8w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3581mqrrqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 08 Dec 2020 04:53:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B84ngKV145396;
        Tue, 8 Dec 2020 04:53:03 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 358m4x76fh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Dec 2020 04:53:02 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B84r18O016177;
        Tue, 8 Dec 2020 04:53:01 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 20:53:01 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Colin King <colin.king@canonical.com>, linux-scsi@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: pm8001: remove space in a debug message
Date:   Mon,  7 Dec 2020 23:52:57 -0500
Message-Id: <160740315201.1143.13169163294791547714.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201124093828.307709-1-colin.king@canonical.com>
References: <20201124093828.307709-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012080029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012080029
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 24 Nov 2020 09:38:28 +0000, Colin King wrote:

> There are two words that need separating with a space in a
> pm8001_dbg message. Fix it.

Applied to 5.11/scsi-queue, thanks!

[1/1] scsi: pm8001: remove space in a debug message
      https://git.kernel.org/mkp/scsi/c/c6131854e28a

-- 
Martin K. Petersen	Oracle Linux Engineering
