Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1358EC433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Mar 2022 03:57:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbiCSD6d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Mar 2022 23:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbiCSD6c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Mar 2022 23:58:32 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 997558BF24
        for <linux-scsi@vger.kernel.org>; Fri, 18 Mar 2022 20:57:11 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22J3Bx63000998;
        Sat, 19 Mar 2022 03:57:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=+1+w39jECQ7XXcqGQRrwbJFlTFAcNkIGTLrmoudNViQ=;
 b=IRcdUNKToOxW7GXQ1QLRodmBr3zOsnBzCwkqFAuzSUaU9/clmEAKBfbp/WPXDfC2+zwT
 9CDhqkv/o2tLLpqEnLu+ZNUArjUJU9JeSWW3FDgcT/42rqLtSBQHg8YRKNIokWQQ6QDB
 AiendjrvzM3UgdwfGicXcdn3HifTYhTqDe/bLMr7BGlrmvtmPOUp9DEm7dfeDBeVhtu3
 LZU7k9J670xsAIYEHO9qZi0qzoDCJnnhU1PzTXpd/8uN64mKSKgWhsatsd3F7bHIYixl
 3mujWV3xH6PkgjMkeFfJYDoiBEtcoGhEIqnDZ+VtmQLCSzIWx7cRG3qAUWWnI126WyIv tw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew72a8109-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Mar 2022 03:57:09 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 22J3utTF007031;
        Sat, 19 Mar 2022 03:57:09 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ew5kyshng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Mar 2022 03:57:09 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 22J3v5Qi007126;
        Sat, 19 Mar 2022 03:57:08 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ew5kyshmn-4;
        Sat, 19 Mar 2022 03:57:08 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/17] lpfc: Update lpfc to revision 14.2.0.0
Date:   Fri, 18 Mar 2022 23:56:54 -0400
Message-Id: <164766213029.31329.8723612713622401999.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220225022308.16486-1-jsmart2021@gmail.com>
References: <20220225022308.16486-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 9LvSQDmKplJWB_NnfXazvxLMoElPTxx5
X-Proofpoint-ORIG-GUID: 9LvSQDmKplJWB_NnfXazvxLMoElPTxx5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 24 Feb 2022 18:22:51 -0800, James Smart wrote:

> Update lpfc to revision 14.2.0.0
> 
> This patch set is a refactoring of the lpfc driver.
> 
> The lpfc driver was first implemented for sli-3 then had sli-4 added
> to it. The addition of sli-4 was done in a manner where the sli-3 paths
> were left in place with sli-3 structures converted to sli-4 when written
> to the adapter. Similar behavior for responses. Over time we've been hit
> with subtle sli3 vs sli4 structure formats issues, bits defined on sli3
> that aren't on sli4 or vice versa, that the driver wasn't careful about.
> The subtleties caused bogus settings to be passed when the eventually
> overlapped, or expected values that never we set by the hw.
> 
> [...]

Applied to 5.18/scsi-queue, thanks!

[01/17] lpfc: SLI path split: refactor lpfc_iocbq
        https://git.kernel.org/mkp/scsi/c/a680a9298e7b
[02/17] lpfc: SLI path split: refactor fast and slow paths to native sli4
        https://git.kernel.org/mkp/scsi/c/1b64aa9eae28
[03/17] lpfc: SLI path split: introduce lpfc_prep_wqe
        https://git.kernel.org/mkp/scsi/c/561341425bcc
[04/17] lpfc: SLI path split: refactor base els paths and the FLOGI path
        https://git.kernel.org/mkp/scsi/c/6831ce129f19
[05/17] lpfc: SLI path split: refactor PLOGI/PRLI/ADISC/LOGO paths
        https://git.kernel.org/mkp/scsi/c/cad93a089031
[06/17] lpfc: SLI path split: refactor the RSCN/SCR/RDF/EDC/FARPR paths
        https://git.kernel.org/mkp/scsi/c/3bea83b68d54
[07/17] lpfc: SLI path split: refactor LS_ACC paths
        https://git.kernel.org/mkp/scsi/c/3f607dcb43f1
[08/17] lpfc: SLI path split: refactor LS_RJT paths
        https://git.kernel.org/mkp/scsi/c/e0367dfe90d6
[09/17] lpfc: SLI path split: refactor FDISC paths
        https://git.kernel.org/mkp/scsi/c/9d41f08aa2eb
[10/17] lpfc: SLI path split: refactor VMID paths
        https://git.kernel.org/mkp/scsi/c/351849800157
[11/17] lpfc: SLI path split: refactor misc ELS paths
        https://git.kernel.org/mkp/scsi/c/2d1928c57df6
[12/17] lpfc: SLI path split: refactor CT paths
        https://git.kernel.org/mkp/scsi/c/61910d6a5243
[13/17] lpfc: SLI path split: refactor SCSI paths
        https://git.kernel.org/mkp/scsi/c/3512ac094293
[14/17] lpfc: SLI path split: refactor Abort paths
        https://git.kernel.org/mkp/scsi/c/31a59f75702f
[15/17] lpfc: SLI path split: refactor BSG paths
        https://git.kernel.org/mkp/scsi/c/0e082d926f59
[16/17] lpfc: Update lpfc version to 14.2.0.0
        https://git.kernel.org/mkp/scsi/c/64de6108f410
[17/17] lpfc: Copyright updates for 14.2.0.0 patches
        https://git.kernel.org/mkp/scsi/c/f45775bf562a

-- 
Martin K. Petersen	Oracle Linux Engineering
