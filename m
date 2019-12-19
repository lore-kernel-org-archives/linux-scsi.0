Return-Path: <SRS0=QEZ7=2J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD0B4C43603
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 23:52:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A30192467E
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 23:52:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mP9dzk7Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfLSXwh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Dec 2019 18:52:37 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38484 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726964AbfLSXwh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Dec 2019 18:52:37 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBJNnfKb109553;
        Thu, 19 Dec 2019 23:52:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=zywcEs2hhoNSnHahJi++zcf+8e3ziBWkyoEcIZrfiuI=;
 b=mP9dzk7ZRp5Dxm1avtC82zRfYT5i2yVtBT3oPabdVpr2hDeDhn68l5lcWL93XeeGGNol
 cS31h+CYlQocjKy9Ml9MTlkwPjJs5b18hBU/sM3Kqh8vx3smf+Rqh0GGVocCgipWyD8O
 bmpe1SrkS3SrZubTK0SUkNCOxVK0TP3KiBTyKp2ZP4aUrON7B2p0IUvc6rPAdvXO47ZS
 O9Q6PUqUSUdRnBO5dej+M7XqBjeY5m/tvrvMgU7+RvqVfjPbCoLhzISFqfRz0ltA1P+I
 uT8DVRWOUXGKX+aBi/rCtbDGTBeIAPSRb9QPhNgLf+DgQK8xviyOdc1n8YxlbAp2bYO0 2g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2x01jadv9x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Dec 2019 23:52:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBJNnapo099977;
        Thu, 19 Dec 2019 23:52:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2x0bgmmj4y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Dec 2019 23:52:29 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBJNqSc3013940;
        Thu, 19 Dec 2019 23:52:28 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Dec 2019 15:52:28 -0800
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Hannes Reinecke <hare@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] scsi: aic7xxx: Adjust indentation in ahc_find_syncrate
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191218014220.52746-1-natechancellor@gmail.com>
Date:   Thu, 19 Dec 2019 18:52:26 -0500
In-Reply-To: <20191218014220.52746-1-natechancellor@gmail.com> (Nathan
        Chancellor's message of "Tue, 17 Dec 2019 18:42:20 -0700")
Message-ID: <yq1mubnan5x.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9476 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=829
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912190174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9476 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=892 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912190174
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nathan,

> Clang warns:
>
> ../drivers/scsi/aic7xxx/aic7xxx_core.c:2317:5: warning: misleading
> indentation; statement is not part of the previous 'if'
> [-Wmisleading-indentation]
>                         if ((syncrate->sxfr_u2 & ST_SXFR) != 0)
>                         ^
> ../drivers/scsi/aic7xxx/aic7xxx_core.c:2310:4: note: previous statement

Applied to 5.6/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
