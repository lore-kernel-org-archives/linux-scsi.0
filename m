Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43A86C5517A
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 02:59:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E62AA2168B
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 02:59:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A0M34CkL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725923AbgKKC7Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Nov 2020 21:59:16 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:35544 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbgKKC7Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2020 21:59:16 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB2tGBZ060458;
        Wed, 11 Nov 2020 02:59:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=RHSiV6Cy3xH7Gk12UYgnMk7ukXnbqA90vVazWq24mPw=;
 b=A0M34CkL5COK0FcS5HqhZcas1f02qUTwwg1NIo1TU3JpldN/leDpT5snbYc3uDIuaw4b
 7ZhATn4R5GliEtWgSXO41cMHxzjc5FVCwyeP6GI6VjaADAkoBG7hY5tiEyWKUa6atMa5
 RiGlVnMuu6yDMRyrmzeyZbIXK+OycsOME+iYOgmBuBmI9fWZY2krwbqrxvnXXn2RiaPQ
 r9Jm6nFnIswI3okxaQqnR9BDgFPxhTPWiABAC2waUkL9tEhDUnbx/jR/3se1HjywzOhx
 nZy/GauYwoYXRtQ1rBoXYhAkL8MylQzw/Ce2iBz+gDLcKznvsZ2UfsrRGBrsqxTue1AN WA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34p72en4bu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 02:59:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB2u9xW079031;
        Wed, 11 Nov 2020 02:59:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 34p5gxt60m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 02:59:13 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AB2xCnr018004;
        Wed, 11 Nov 2020 02:59:12 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 18:59:11 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, James Smart <james.smart@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/9] lpfc: Update lpfc to revision 12.8.0.5
Date:   Tue, 10 Nov 2020 21:59:07 -0500
Message-Id: <160506354082.14637.10178726374638223021.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201020202719.54726-1-james.smart@broadcom.com>
References: <20201020202719.54726-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110012
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 20 Oct 2020 13:27:10 -0700, James Smart wrote:

> Update lpfc to revision 12.8.0.5
> 
> Patches include several small fixes and the addition of a FDMI
> registration for vendor MIB data.
> 
> The patches were cut against Martin's 5.10/scsi-queue tree
> 
> [...]

Applied to 5.11/scsi-queue, thanks!

[1/9] scsi: lpfc: Fix invalid sleeping context in lpfc_sli4_nvmet_alloc()
      https://git.kernel.org/mkp/scsi/c/62e3a931db60
[2/9] scsi: lpfc: Fix scheduling call while in softirq context in lpfc_unreg_rpi
      https://git.kernel.org/mkp/scsi/c/e7dab164a9aa
[3/9] scsi: lpfc: Re-fix use after free in lpfc_rq_buf_free()
      https://git.kernel.org/mkp/scsi/c/e5785d3ec32f
[4/9] scsi: lpfc: Removed unused macros in lpfc_attr.c
      https://git.kernel.org/mkp/scsi/c/7cbef585a12a
[5/9] scsi: lpfc: Fix duplicate wq_create_version check
      https://git.kernel.org/mkp/scsi/c/f5201f87ccaf
[6/9] scsi: lpfc: Enlarge max_sectors in scsi host templates
      https://git.kernel.org/mkp/scsi/c/7c30bb62ed5d
[7/9] scsi: lpfc: Add FDMI Vendor MIB support
      https://git.kernel.org/mkp/scsi/c/8aaa7bcf07a2
[8/9] scsi: lpfc: Reject CT request for MIB commands
      https://git.kernel.org/mkp/scsi/c/b67b59443282
[9/9] scsi: lpfc: Update lpfc version to 12.8.0.5
      https://git.kernel.org/mkp/scsi/c/56ae4919f9ed

-- 
Martin K. Petersen	Oracle Linux Engineering
