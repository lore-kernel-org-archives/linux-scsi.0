Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8FC2C35280
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 02:54:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92526208CA
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 02:54:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ENUQhNT4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbgEHCyn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 22:54:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33514 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbgEHCyn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 22:54:43 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0482sej8097687;
        Fri, 8 May 2020 02:54:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=2yKd6RpDTuDwdRaJLA+KoWLo07/aHkyB1yWqHOoAZLM=;
 b=ENUQhNT4k5ztDA9FXOj1wCLOHuaBvLRRBFkNO7TGcGuoXlAGZBiwZw59OW5SKCEclQB0
 RufxDtEJUZGhDkWzRtTOBHXw243a69cRrbsac2GtcsZhAH0Gsu49o/pi2z9cep9ml+PC
 C/dkL3IndYHLLQGR5ZplJ7HjrEsZZLVClcFfrqnkpVvuQLTi9Xx0i6tF0EimwIm0uPV0
 1MrPeYaVkHjVtBIE197jFrHBPN7y7OHYj80nCBuUU6y35thnd8RHkNsi5QWJFo+yEZ0G
 Qf/FlbmuPYz0fQL/HRRqww4sETFCFXQ+VWTH4nxfgCGcarc3/YsqE8seqG1O0VESyQF0 zw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30vtexrrks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 02:54:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0482qv7Z138432;
        Fri, 8 May 2020 02:54:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 30vtdmp559-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 02:54:39 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0482scEP006350;
        Fri, 8 May 2020 02:54:38 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 May 2020 19:54:38 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/9] lpfc: Update lpfc to revision 12.8.0.1
Date:   Thu,  7 May 2020 22:54:24 -0400
Message-Id: <158890633247.6466.6397556397074532174.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501214310.91713-1-jsmart2021@gmail.com>
References: <20200501214310.91713-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005080022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 spamscore=0 suspectscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 phishscore=0 impostorscore=0 mlxscore=0 mlxlogscore=999 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005080022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 1 May 2020 14:43:01 -0700, James Smart wrote:

> Update lpfc to revision 12.8.0.1
> 
> Patch set contains several small fixes, code cleanups, a change to
> default number of hdwqs at init, and a sync of devloss with the
> nvme-fc transport.
> 
> The patches were cut against Martin's 5.8/scsi-queue tree
> 
> [...]

Applied to 5.8/scsi-queue, thanks!

[2/9] scsi: lpfc: Maintain atomic consistency of queue_claimed flag
      https://git.kernel.org/mkp/scsi/c/164ba8d2df66
[3/9] scsi: lpfc: Remove re-binding of nvme rport during registration
      https://git.kernel.org/mkp/scsi/c/b98214f6070e
[4/9] scsi: lpfc: Fix negation of else clause in lpfc_prep_node_fc4type
      https://git.kernel.org/mkp/scsi/c/f809da6db68a
[5/9] scsi: lpfc: Change default queue allocation for reduced memory consumption
      https://git.kernel.org/mkp/scsi/c/3048e3e805e3
[6/9] scsi: lpfc: Remove unnecessary lockdep_assert_held calls
      https://git.kernel.org/mkp/scsi/c/88acb4d9ff98
[7/9] scsi: lpfc: Fix noderef and address space warnings
      https://git.kernel.org/mkp/scsi/c/a7fc071ab56e
[8/9] scsi: lpfc: Fix MDS Diagnostic Enablement definition
      https://git.kernel.org/mkp/scsi/c/8cdc5a223ed0
[9/9] scsi: lpfc: Update lpfc version to 12.8.0.1
      https://git.kernel.org/mkp/scsi/c/29022b61307f

-- 
Martin K. Petersen	Oracle Linux Engineering
