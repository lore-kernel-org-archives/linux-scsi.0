Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07CEDC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jan 2022 05:44:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236079AbiAYFoL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jan 2022 00:44:11 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:49062 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235486AbiAYFlM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Jan 2022 00:41:12 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20P1p4TA016140;
        Tue, 25 Jan 2022 05:41:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=Exo/EjFE8TXvAv+/JMTp26v6d/zU4zSiJaNlQN+iXFY=;
 b=cpKNiIEx3PiqIbMlj4qWa3jCzgRRr7znjE0D5rd3iqSwil1Lg5W8Yq7tjYWgwNoWk5ho
 q/LiqFn6gMiHDF1wPl7/+naEaZjzFnRcHmRwSh0NhkPjdB0Sw4iat/aNeUn/1jReQqVX
 uhSwhRVEutmqFV00eMo7hwjZn6k0QQ9kum5mN54r/WEgrmKShhLKkGfww2Zl/G4ohkgu
 /fXWTbFLCdZocAhJXA7K3LWsYmJ7OHhdAy9keAJROApu5NNX2cryEh6CbacQR/T0AiTe
 9/rGJJWk/xTIXnvsBxud8UhGXCbJWWsj8LkFwYcmUtxHMvyqYXf4W8H4jPdntkbNqQw3 8w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dsxvfhw49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jan 2022 05:41:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20P5evWU181750;
        Tue, 25 Jan 2022 05:41:04 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3dr71x1ssj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jan 2022 05:41:04 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 20P5evOf181790;
        Tue, 25 Jan 2022 05:41:04 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3030.oracle.com with ESMTP id 3dr71x1sgc-8;
        Tue, 25 Jan 2022 05:41:04 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com, loberman@redhat.com,
        linux-scsi@vger.kernel.org, jpittman@redhat.com
Subject: Re: [PATCH 0/3] qedf misc bug fixes
Date:   Tue, 25 Jan 2022 00:40:44 -0500
Message-Id: <164308671270.32373.8038545840370572527.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220117135311.6256-1-njavali@marvell.com>
References: <20220117135311.6256-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: KLnF9JLZ6qPg1COUFUyyaMbuMdiKie-t
X-Proofpoint-ORIG-GUID: KLnF9JLZ6qPg1COUFUyyaMbuMdiKie-t
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 17 Jan 2022 05:53:08 -0800, Nilesh Javali wrote:

> Martin,
> 
> Please apply the qedf driver misc bug fixes to the scsi tree
> at your earliest convenience.
> 
> Thanks,
> Nilesh
> 
> [...]

Applied to 5.17/scsi-fixes, thanks!

[1/3] qedf: Add stag_work to all the vports
      https://git.kernel.org/mkp/scsi/c/b70a99fd1328
[2/3] qedf: Fix refcount issue when LOGO is received during TMF
      https://git.kernel.org/mkp/scsi/c/5239ab63f17c
[3/3] qedf: Change context reset messages to ratelimited
      https://git.kernel.org/mkp/scsi/c/64fd4af6274e

-- 
Martin K. Petersen	Oracle Linux Engineering
