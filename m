Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC63FC433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Apr 2022 13:36:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343720AbiDGNh4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Apr 2022 09:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343683AbiDGNhd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2022 09:37:33 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC6521A9
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 06:35:29 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 237Bt3d1001019
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=8t+LjSAn8N571UcgWIIJMlPGDRmO37jniBHbLHYAltQ=;
 b=lp8L/RLCrFAGOjOvjSnnjpu+D6DfaNxsE6oxdcB+eKw4Tu/aprpoNjjMw5TTyYucNYnR
 shjmZA/2S60IraaTeioM5tX7BBeDvhVh6hOQ1EuJIuvIfEbr7wf6lruwNglncyYszPL1
 OA8oJKqaaoP2ZVl8FjmjkfnuGNZ2UeBb2jjwdMPi5QEaxUmM7WSKlW4RjfRhjytdzPyd
 4gi5CVQWMPbqqAslX7jtziMjHQuOFJUcalHqyxPX7um8Qe2ffvUFYvAUCwcQscej/lDr
 ElI3sp9staQXXHypJwWM2yfduPdfACUStBfYp1yJ4OTN6vozP9934kM7VBfClruY/TGQ ww== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6e3suw27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 07 Apr 2022 13:35:28 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 237DLVcF036832
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97uwtvwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 07 Apr 2022 13:35:27 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 237DZJM2032479
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:27 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97uwtvpy-11;
        Thu, 07 Apr 2022 13:35:27 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: core: Remove unused field in struct ufs_hba
Date:   Thu,  7 Apr 2022 09:35:10 -0400
Message-Id: <164929678998.15424.14809520929798140145.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <413601558.101648105683746.JavaMail.epsvc@epcpadp4>
References: <CGME20220324070146epcms2p577d43ce3e7cbd36aa964f3842e49b2ba@epcms2p5> <413601558.101648105683746.JavaMail.epsvc@epcpadp4>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: wdW_Ejh3_aGg8NrBB_pt_yE-RA7JCP41
X-Proofpoint-GUID: wdW_Ejh3_aGg8NrBB_pt_yE-RA7JCP41
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 24 Mar 2022 16:01:46 +0900, Keoseong Park wrote:

> Remove unused field "rpm_lvl_attr" and "spm_lvl_attr" in struct ufs_hba.
> Commit cbb6813ee771 ("scsi: ufs: sysfs: attribute group for existing
> sysfs entries.") removed all code using that field.
> 
> 

Applied to 5.18/scsi-fixes, thanks!

[1/1] scsi: ufs: core: Remove unused field in struct ufs_hba
      https://git.kernel.org/mkp/scsi/c/8ee15ea779c3

-- 
Martin K. Petersen	Oracle Linux Engineering
