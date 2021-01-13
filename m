Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC209C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 05:49:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87C042225E
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 05:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbhAMFt0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 00:49:26 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:33792 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbhAMFt0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2021 00:49:26 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D5ha77166607;
        Wed, 13 Jan 2021 05:48:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=wYhsKu9BSZ+pRiNiAtqcpk1WXAXbUtbCxKbj8ISp4IA=;
 b=MfEAdu11k3eUE4tZrKsRF+yz9a4+SNSbAJkwgeGnb5f+KuAFZXLlY1zXrY5pyxkezp2x
 r0R4e2v43P2juaKwAuLFwyAmWrDnq/2adG+e9arTE+RZgtndz7cLyXNlJGWa4SjQfKUr
 tH4oAXTzCUfMKoBwGU46Rq1/pU4oN4q+ZTzAy+0iObAAseOgGSekHy9Z4vzdScsH6jty
 8QQdCUXzYPgKj9zQO1PpTfraauR87M8ttRS9sny9gyAusuYvPdHTtOKp/OkM6P0xAHwN
 3sIACqB36KEnV6TQWBnH/QMrdkrALQi9xJtpTgqe8SQgaxxN89qrXrSQhdQearJGv9Fv AQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 360kg1snsb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 05:48:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D5e5q9133922;
        Wed, 13 Jan 2021 05:48:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 360kf00pqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 05:48:44 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10D5mhgx011640;
        Wed, 13 Jan 2021 05:48:43 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Jan 2021 21:48:34 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 00/15] lpfc: Update lpfc to revision 12.8.0.7
Date:   Wed, 13 Jan 2021 00:48:24 -0500
Message-Id: <161050726820.14224.8991501570955551588.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210104180240.46824-1-jsmart2021@gmail.com>
References: <20210104180240.46824-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 adultscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130034
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 clxscore=1015 impostorscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130034
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 4 Jan 2021 10:02:25 -0800, James Smart wrote:

> Update lpfc to revision 12.8.0.7
> 
> This patch set contains fixes and a cleanup of trace logging.
> 
> The patches were cut against Martin's 5.11/scsi-queue tree

Applied to 5.12/scsi-queue, thanks!

[01/15] lpfc: Fix PLOGI S_ID of 0 on pt2pt config
        https://git.kernel.org/mkp/scsi/c/8e062ce305ad
[02/15] lpfc: Fix auto sli_mode and its effect on CONFIG_PORT for SLI3
        https://git.kernel.org/mkp/scsi/c/d2f2547efd39
[03/15] lpfc: Refresh ndlp when a new PRLI is received in the PRLI issue state
        https://git.kernel.org/mkp/scsi/c/ecf041fe9895
[04/15] lpfc: Fix crash when a fabric node is released prematurely.
        https://git.kernel.org/mkp/scsi/c/07aaefdf75c5
[05/15] lpfc: Use the nvme-fc transport supplied timeout for LS requests
        https://git.kernel.org/mkp/scsi/c/c33b1609344f
[06/15] lpfc: Fix FW reset action if IOs are outstanding
        https://git.kernel.org/mkp/scsi/c/3ba6216aaded
[07/15] lpfc: Prevent duplicate requests to unregister with cpuhp framework
        https://git.kernel.org/mkp/scsi/c/f0871ab68a8b
[08/15] lpfc: Fix error log messages being logged following scsi task mgnt
        https://git.kernel.org/mkp/scsi/c/da09ae4864e1
[09/15] lpfc: Fix target reset failing
        https://git.kernel.org/mkp/scsi/c/31051249f12e
[10/15] lpfc: Fix NVME recovery after mailbox timeout
        https://git.kernel.org/mkp/scsi/c/9ec58ec7d41a
[11/15] lpfc: Fix vport create logging
        https://git.kernel.org/mkp/scsi/c/ff8a44bff5ef
[12/15] lpfc: Fix crash when nvmet transport calls host_release
        https://git.kernel.org/mkp/scsi/c/243156c0108d
[13/15] lpfc: Implement health checking when aborting io
        https://git.kernel.org/mkp/scsi/c/a22d73b655a8
[14/15] lpfc: Enhancements to LOG_TRACE_EVENT for better readability
        https://git.kernel.org/mkp/scsi/c/0b3ad32e2646
[15/15] lpfc: Update lpfc version to 12.8.0.7
        https://git.kernel.org/mkp/scsi/c/181dd9a4c2c6

-- 
Martin K. Petersen	Oracle Linux Engineering
