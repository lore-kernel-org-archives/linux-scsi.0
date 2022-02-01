Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E27EC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Feb 2022 02:04:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbiBACE3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 21:04:29 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:9882 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232093AbiBACE2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 31 Jan 2022 21:04:28 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20VLRFcQ010605;
        Tue, 1 Feb 2022 02:04:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=u8Biqju8uxsy90y0miCvbj5Qq5AHWw/tZ60UYKDkS8c=;
 b=y2HN+SzUcuGGtq7TUULnpOpl0w6+BoOVU2SUlWAuKTwK693xjMiW0dEXp1ZBwJ2Fd6UM
 PwyS5vV9LGrNZM8GZ+jQTcBcwpgAMPnOI9Qp5IvQnoBCYQciEHS6dezB1fB0d9rRSK4n
 8or38+VgNBAghHSL1L6G2te0iWP6SLNIfxsYDkqcpVK5IgdNfPaqgSlk+UFxC1e0Yftg
 lLrX7NrIf43OaAs/4APPxrJ6Pvll4o2m/i99Db/oUbEUgylRX2rVyRfF9/ocXQKtFFuH
 IIUKIkHUehNU3KtVMWJzazvcdul+d4lEQTyd/ideZIwTZpz6Fv6pSkTwP2DjlTE3TuuC sw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dxjatsgwm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Feb 2022 02:04:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2111t6Aq097931;
        Tue, 1 Feb 2022 02:04:26 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3dvwd5a8d8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Feb 2022 02:04:26 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 21124Pp3124522;
        Tue, 1 Feb 2022 02:04:26 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3020.oracle.com with ESMTP id 3dvwd5a8ck-2;
        Tue, 01 Feb 2022 02:04:25 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH v2 00/17] qla2xxx misc bug fixes and features
Date:   Mon, 31 Jan 2022 21:04:23 -0500
Message-Id: <164368101884.23527.12869265102876383409.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220110050218.3958-1-njavali@marvell.com>
References: <20220110050218.3958-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: LpB_2Xdo7shVVZIN8kApvK-Mbq1LcTFY
X-Proofpoint-ORIG-GUID: LpB_2Xdo7shVVZIN8kApvK-Mbq1LcTFY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 9 Jan 2022 21:02:01 -0800, Nilesh Javali wrote:

> Martin,
> 
> Please apply the qla2xxx driver misc bug fixes and features to the scsi
> tree at your earliest convenience.
> 
> Thanks,
> Nilesh
> 
> [...]

Applied to 5.18/scsi-queue, thanks!

[01/17] qla2xxx: Refactor asynchronous command initialization
        https://git.kernel.org/mkp/scsi/c/d4523bd6fd5d
[02/17] qla2xxx: Implement ref count for srb
        https://git.kernel.org/mkp/scsi/c/31e6cdbe0eae
[03/17] qla2xxx: fix stuck session in gpdb
        https://git.kernel.org/mkp/scsi/c/725d3a0d31a5
[04/17] qla2xxx: Fix warning message due to adisc is being flush
        https://git.kernel.org/mkp/scsi/c/64f24af75b79
[05/17] qla2xxx: Fix premature hw access after pci error
        https://git.kernel.org/mkp/scsi/c/e35920ab7874
[06/17] qla2xxx: Fix scheduling while atomic
        https://git.kernel.org/mkp/scsi/c/afd438ff874c
[07/17] qla2xxx: add retry for exec fw
        https://git.kernel.org/mkp/scsi/c/355f5ffe840a
[08/17] qla2xxx: Show wrong FDMI data for 64G adaptor
        https://git.kernel.org/mkp/scsi/c/1cfbbacbee2d
[09/17] qla2xxx: Add ql2xnvme_queues module param to configure number of NVME queues
        https://git.kernel.org/mkp/scsi/c/65120de26a54
[10/17] qla2xxx: Fix device reconnect in loop topology
        https://git.kernel.org/mkp/scsi/c/8ad4be3d15cf
[11/17] qla2xxx: fix warning for missing error code
        https://git.kernel.org/mkp/scsi/c/14cb838d245a
[12/17] qla2xxx: edif: Fix clang warning
        https://git.kernel.org/mkp/scsi/c/73825fd7a37c
[13/17] qla2xxx: Fix T10 PI tag escape and IP guard options for 28XX adapters
        https://git.kernel.org/mkp/scsi/c/4c103a802c69
[14/17] qla2xxx: Suppress a kernel complaint in qla_create_qpair()
        https://git.kernel.org/mkp/scsi/c/a60447e7d451
[15/17] qla2xxx: Add devid's and conditionals for 28xx
        https://git.kernel.org/mkp/scsi/c/0d6a536cb1fc
[16/17] qla2xxx: check for firmware dump already collected
        https://git.kernel.org/mkp/scsi/c/cfbafad7c603
[17/17] qla2xxx: Update version to 10.02.07.300-k
        https://git.kernel.org/mkp/scsi/c/0dd392d16db4

-- 
Martin K. Petersen	Oracle Linux Engineering
