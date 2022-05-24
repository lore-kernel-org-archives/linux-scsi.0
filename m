Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31F04C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 24 May 2022 18:12:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240265AbiEXSMG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 May 2022 14:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240230AbiEXSMA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 May 2022 14:12:00 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98FE5DD39;
        Tue, 24 May 2022 11:11:57 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OHnit7016208;
        Tue, 24 May 2022 18:11:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=RWSN9gfha2h4w8TQrYFBAWOeUnKWsJDbgvBdRPpgYsI=;
 b=C1ZE3Nge4QgeckOYsgxkiH6dMuEDdDUrUtSJSTJ22kHWgauXvp1mth1aPLGjRjuCfh4O
 qY14b+XOLgP7Kgy6M77dcfu3M/5fUCBO+wDKqG6QH6PlTEWH7UIFd7at8OqgH0kN0Nk+
 BHaNn6L0FfjhbataDX20zaTrAE9ehUdkgij1XJhHJJqGgsE36StvO2awUSJv5ExIeUFd
 rM5wGDTFeckpzHLN3D931l+ZSJV+HgXe0Yw5CZCXEGWOr9g02Iy8cFzL+KJi2lu59C3C
 Q/nfn3mQv42njlv8Erqx4xhl4V/sfD6vJ+LtcwlkwP+K/B4OJ7/ivgnpqcCWcoQj/QBZ 5w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g93tdr3et-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 18:11:47 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24OHwP4d040074;
        Tue, 24 May 2022 18:11:46 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g93x50s53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 18:11:46 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 24OIAvn2039045;
        Tue, 24 May 2022 18:11:45 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g93x50s3r-5;
        Tue, 24 May 2022 18:11:45 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Julia Lawall <Julia.Lawall@inria.fr>,
        Bradley Grove <linuxdrivers@attotech.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH] scsi: esas2r: fix typo in comment
Date:   Tue, 24 May 2022 14:11:37 -0400
Message-Id: <165341587529.22286.6725964458103300262.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220521111145.81697-40-Julia.Lawall@inria.fr>
References: <20220521111145.81697-40-Julia.Lawall@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: gnHC9ife9HUMzIMiM_aTTg7MCdMJfZ3c
X-Proofpoint-ORIG-GUID: gnHC9ife9HUMzIMiM_aTTg7MCdMJfZ3c
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 21 May 2022 13:10:50 +0200, Julia Lawall wrote:

> Spelling mistake (triple letters) in comment.
> Detected with the help of Coccinelle.
> 
> 

Applied to 5.19/scsi-queue, thanks!

[1/1] scsi: esas2r: fix typo in comment
      https://git.kernel.org/mkp/scsi/c/0676f275837c

-- 
Martin K. Petersen	Oracle Linux Engineering
