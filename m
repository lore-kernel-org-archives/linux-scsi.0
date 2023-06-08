Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CB26C7EE2F
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jun 2023 01:43:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233016AbjFHBnN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 21:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233529AbjFHBm5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 21:42:57 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446B7271F
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jun 2023 18:42:46 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 357NRKT8018013;
        Thu, 8 Jun 2023 01:42:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=e65AxurfDdXbQwxvTbqiDm6YevtF1hHSTwR4UdLA1tY=;
 b=Rzf2hSMKu7gi299WdiLrEc7Twj5bvDXSxpeS2IbRC4kwrwIzRfcd8OrvS6AIoTfJRjK9
 e9QClKRItFSnJNzDyj7QlLRAE3sw3yKTi8+FDRV0zYGn8SE3HFGh6qmQAmOkMB8ptNY8
 IWao5vF6GxpUjaCn6LtyWvfr20+QDiChEv7saTu6EMLZKdGEoQVSKwChLmnaXUWY998b
 auk0Vpllayayz0y/Yb1AR2FHPe0zLEIWcXNEX2NtoLpksfsTkJeHiK/QZm/XPaR97+AZ
 3gBThlul0lB3a85aMRvPTMorPJm1pHpQJaOgGqOMiz0AKSmO4wygfzQxXz3uZkTQLcZS HQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r2a6ub3h9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Jun 2023 01:42:42 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 357NR3wq036935;
        Thu, 8 Jun 2023 01:42:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r2a6hyt9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Jun 2023 01:42:41 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3581gQV1031871;
        Thu, 8 Jun 2023 01:42:41 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3r2a6hyt3a-12;
        Thu, 08 Jun 2023 01:42:41 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] ata: libata-scsi: fix ata_msense_control kdoc comment
Date:   Wed,  7 Jun 2023 21:42:16 -0400
Message-Id: <168618844254.2636448.3391306384144657410.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230523074701.293502-1-dlemoal@kernel.org>
References: <20230523074701.293502-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-07_13,2023-06-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 adultscore=0 mlxlogscore=783 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306080011
X-Proofpoint-GUID: gxRCO2j1-1H8BLZAZT_JLVVqboPkyv64
X-Proofpoint-ORIG-GUID: gxRCO2j1-1H8BLZAZT_JLVVqboPkyv64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 23 May 2023 16:47:01 +0900, Damien Le Moal wrote:

> Add missing description of the spg argument of ata_msense_control().
> 
> 

Applied to 6.5/scsi-queue, thanks!

[1/1] ata: libata-scsi: fix ata_msense_control kdoc comment
      https://git.kernel.org/mkp/scsi/c/401f8ef3193f

-- 
Martin K. Petersen	Oracle Linux Engineering
