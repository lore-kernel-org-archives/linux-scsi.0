Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CABEC433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 06:07:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 651022078C
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 06:07:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qoLV49LC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728840AbgGHGHI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 02:07:08 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59306 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbgGHGHH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 02:07:07 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06866pLJ045649;
        Wed, 8 Jul 2020 06:07:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=5ruWp+9PNArsGqnhm9xr7MKSa7IuE7jbRly7UNM0tks=;
 b=qoLV49LCjiG4kLhn09ZK2WoDEpSIurc739haL71rdSnRJ+Rb4e2Ki2socVeK/cjt3Jiz
 sZ1KeVIlXXFIGBAVwdPM2k+5pED3Ga3CEtqR/bD1DnEBnltYrjQ+eckcWWL7hZlxPalh
 HudL28/TrWBUlimOUj9X01qIHGNpIVk+L4NgROmZLW6qnHiVkVkYQZGnNmAI2FowAdKi
 1tycCyWEPyleUEieK1S7bkfKzYwYPdPSuSh5LhKCw6FlhPZVCmeViT+IMvlXoUUBWkAc
 wto1M0UGPxPjmQDe5rGXeSFNsDdVkKMXsIUsXe1/6lyj0qKOSl607tVO1RZCI1Nnxz8b 2w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 322kv6g9ff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 08 Jul 2020 06:07:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0685xBr0063833;
        Wed, 8 Jul 2020 06:07:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 3233p4k2du-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jul 2020 06:07:01 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 068670xY030643;
        Wed, 8 Jul 2020 06:07:00 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jul 2020 23:07:00 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Colin King <colin.king@canonical.com>,
        James Smart <james.smart@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH][next] scsi: lpfc: fix inconsistent indenting
Date:   Wed,  8 Jul 2020 02:06:47 -0400
Message-Id: <159418828150.5152.17012831289512414220.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200707150018.823350-1-colin.king@canonical.com>
References: <20200707150018.823350-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9675 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=883
 mlxscore=0 spamscore=0 bulkscore=0 malwarescore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007080041
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9675 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=904 phishscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 mlxscore=0 adultscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007080042
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 7 Jul 2020 16:00:18 +0100, Colin King wrote:

> Fix smatch warning:
> drivers/scsi/lpfc/lpfc_sli.c:15156 lpfc_cq_poll_hdler() warn: inconsistent
> indenting

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: lpfc: Fix inconsistent indenting
      https://git.kernel.org/mkp/scsi/c/26e0b9aa3578

-- 
Martin K. Petersen	Oracle Linux Engineering
