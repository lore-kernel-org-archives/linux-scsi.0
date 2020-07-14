Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABF9BC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 04:59:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 800372193E
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 04:59:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zhsoOm3N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgGNE7B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 00:59:01 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37574 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgGNE7A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2020 00:59:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E4vVSk172890;
        Tue, 14 Jul 2020 04:58:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=RLaIa/I6HqRzn5xMEjyR5F2vSVuUvzsasBEBKIz7svU=;
 b=zhsoOm3NZNSSQMgisgcq6QD2vVXgA/S6vynvztS2yl26tIUafm+61Jf5q2TRQaiBBR0w
 CCmbqDRmIdWZEfGNwEoQ+sExJSEZxqvsJI/yvSlIYadJQLUfMqoTPKzRn5AI/OFIkNDY
 Enx6+Spd5SkD/bNw50cEthoUHa319RHzRkDGuK8HRWhenoPxm8qTFExXazkbxZrdga5+
 mSAJgEv1kRYCFTbomIuMFG2ZsCfNW/JoE9OamvzNjYoLiqe+Wt/4xPWgGp1dTz8XtL2x
 FR5SKHPbsZJ3jRPRHsi+1boI77K4CyeV+YgZy7hb9Ki1d0uIsuN/z/j7oRjpgBgl6A2t ww== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 3275cm2x2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 04:58:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E4vXi2174066;
        Tue, 14 Jul 2020 04:58:53 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 327qb2nuhr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 04:58:53 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06E4wpuq025057;
        Tue, 14 Jul 2020 04:58:51 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jul 2020 21:58:51 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>, hare@suse.de,
        jejb@linux.vnet.ibm.com
Subject: Re: [PATCH 0/2] scsi_debug: every_nth cleanup, url + version
Date:   Tue, 14 Jul 2020 00:58:41 -0400
Message-Id: <159470266468.11195.13663399469617326524.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200712182927.72044-1-dgilbert@interlog.com>
References: <20200712182927.72044-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140037
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 12 Jul 2020 14:29:25 -0400, Douglas Gilbert wrote:

> It was becoming hard to follow exactly when to expect the error
> injection facilities in this driver to fire. Sometimes injected
> errors just didn't seem to happen.
> 
> The error injection design was too complicated for what was
> required. Simplify it and make it more consistent. The second
> patch in this set does some housekeeping.
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[1/2] scsi: scsi_debug: every_nth triggered error injection
      https://git.kernel.org/mkp/scsi/c/3a90a63d02b8
[2/2] scsi: scsi_debug: Update documentation url and bump version
      https://git.kernel.org/mkp/scsi/c/30f67481a18b

-- 
Martin K. Petersen	Oracle Linux Engineering
