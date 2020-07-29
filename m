Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FAAAC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 04:10:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 338F320768
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 04:10:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rv1zCGH4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbgG2EKu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 00:10:50 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52684 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbgG2EKt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2020 00:10:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06T41eb9178591;
        Wed, 29 Jul 2020 04:10:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=/V2KgszqZ0DDJHH8eaM4+YEgR6MHzWKwpO9xKz5q7b0=;
 b=rv1zCGH4QbGGyPlKKrQEwQm8MBtjv3LTnvP1D0P4gn8BLz+biKoZgDWar47Bise7AT+a
 s7Ooo1PxDQzK8lzxpRL+52dHyJVND+SXBUP5+OCtinmsIdL6fq+Fl96PwvrlexAV/jGb
 82PwVmZ1DjKjenvSMwEi3p9cyF3zoP7PnIDu+SYoDQPF3ODlKRHz9HY7gGY29ryNA4li
 VVwUUozo5RJS7vH+bGABBpL1W3EyAdPIGTfY/bV+MT4kaO37R1df4HX5BYAVLQuY5+FI
 r0EUd1y1OmgSzC/FuN4AJYZf3ePEVwqyK2Hicvsq80Jb6VkboFMPHYQTVHlw/87wVQOh zg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 32hu1jk62g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 29 Jul 2020 04:10:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06T42kX9150971;
        Wed, 29 Jul 2020 04:10:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 32hu5v59ph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Jul 2020 04:10:45 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06T4AjxJ018616;
        Wed, 29 Jul 2020 04:10:45 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Jul 2020 21:10:44 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <james.smart@broadcom.com>,
        Ferruh Yigit <ferruh.yigit@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: lpfc: Fix typo in comment for ULP
Date:   Wed, 29 Jul 2020 00:10:36 -0400
Message-Id: <159599579269.11289.9677622259387012241.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200728145606.1601726-1-ferruh.yigit@intel.com>
References: <20200728145606.1601726-1-ferruh.yigit@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9696 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 mlxlogscore=910
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007290027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9696 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 mlxlogscore=934
 malwarescore=0 impostorscore=0 priorityscore=1501 spamscore=0 phishscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007290027
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 28 Jul 2020 15:56:06 +0100, Ferruh Yigit wrote:

> UPL -> ULP for "Upper Layer Protocol"

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: lpfc: Fix typo in comment for ULP
      https://git.kernel.org/mkp/scsi/c/02e3e588f0e1

-- 
Martin K. Petersen	Oracle Linux Engineering
