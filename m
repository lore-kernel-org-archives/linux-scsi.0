Return-Path: <SRS0=Wxou=75=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DC9EC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 04:02:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C81020776
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 04:02:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YaYPXYOQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgFPEC1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Jun 2020 00:02:27 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39920 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgFPEC1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jun 2020 00:02:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05G41gx5016996;
        Tue, 16 Jun 2020 04:02:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=jf4K3b2mj36ace3/HKbHB2zxU1z0DgDzozyu9Fhfiek=;
 b=YaYPXYOQImKzKKS1Hh2cI0sLMUd6MssrW5YLx5ZPdMuMbcErFa9Sk94vCJFvapU8s+y8
 RqYWiaDZW5bBMjHMb4vvFFNIv8AcGiW8w11PZgaxLitDfN32HW/wmPaNBU45RCUB50mK
 Zu7oV9bHi+HqqB3OGiG6XG0rExAwD9/GZfIP4eKOETPkV2WoVMiw3aYbD+ERA4vRAxvo
 kFOnKLILyGgnP6LXpk9zleqtZZh66etBzK6mNWqeYgTlp3rSL8mQCix7RPSSFh4r4hzx
 PXh4cU6ygLUWLsBUXNTsnnr/lUGK5vuL59e31t22pp2V9gMpLjjRrRcLYrJ/LdzSArJ2 yw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 31p6s24ajr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 16 Jun 2020 04:02:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05G3w8O4171588;
        Tue, 16 Jun 2020 04:00:09 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 31p6s6mhqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jun 2020 04:00:09 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05G401OF022224;
        Tue, 16 Jun 2020 04:00:02 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Jun 2020 21:00:01 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Flavio Suligoi <f.suligoi@asem.it>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] scsi: mpt3sas: fix spelling mistake
Date:   Mon, 15 Jun 2020 23:59:52 -0400
Message-Id: <159227986422.24883.10063566960810373634.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200609161313.32098-1-f.suligoi@asem.it>
References: <20200609161313.32098-1-f.suligoi@asem.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9653 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006160027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9653 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 clxscore=1011 mlxscore=0 mlxlogscore=999 priorityscore=1501 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 cotscore=-2147483648 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006160028
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 9 Jun 2020 18:13:13 +0200, Flavio Suligoi wrote:

> Fix typo: "tigger" --> "trigger"

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: mpt3sas: Fix spelling mistake
      https://git.kernel.org/mkp/scsi/c/896c9b4907c5

-- 
Martin K. Petersen	Oracle Linux Engineering
