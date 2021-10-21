Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19A8EC433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:43:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0142F60ED3
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:43:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbhJUDqH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 23:46:07 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:58452 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231295AbhJUDpa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Oct 2021 23:45:30 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19L2w9EO029734;
        Thu, 21 Oct 2021 03:43:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=ag6T5J3HY6IIW6RYjctJ302gjD18+S0+kq0Dbz3f2hM=;
 b=a9N52byG4v+MnA+lmVhpXVtEmZq9sEgUXkh8L9MQ0lAehQDELLbFpnBos/+0VIV2UES5
 0NUCSp3rWkFx6+UWEW9fgGCxm8JbIEM+9RzDYz2zL/AVZ4Rj3yuBbROSyEJ47WLzl4gK
 lzefFoLIC4F27hwp0+xsKBgpZnNRYajrlte+2ypLmVL+Y+9ExFVvICfuQ2RRjupPPWTC
 63RS96lxD13mucP6I+w0PJPOPFN4nnevVZQmwKDBiEBSxUR2nbjRGQu8uMSauj6bbVTh
 0TKkZzBVYjS5zJ4j9fFadnj9oIHrNR48HcXlcHIoM7sbe0Whbdg9vdISftoWt9tCYNlD aA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btkwj3ww6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:43:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19L3esRl078107;
        Thu, 21 Oct 2021 03:43:12 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3bqmshem9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:43:12 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19L3gu8K082116;
        Thu, 21 Oct 2021 03:43:12 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3bqmshekyd-18;
        Thu, 21 Oct 2021 03:43:12 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        sathya.prakash@broadcom.com
Subject: Re: [PATCH] scsi_transport_sas: Add 22.5 link rate definitions
Date:   Wed, 20 Oct 2021 23:42:49 -0400
Message-Id: <163478764105.7011.3152020973935984145.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211018070611.26428-1-sreekanth.reddy@broadcom.com>
References: <20211018070611.26428-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: gnk3RuVpEwOIm1loqX6rEzBAG1ZuOMQK
X-Proofpoint-GUID: gnk3RuVpEwOIm1loqX6rEzBAG1ZuOMQK
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 18 Oct 2021 12:36:11 +0530, Sreekanth Reddy wrote:

> Adding 22.5GBPS link rate definitions,
> which are needed for mpi3mr driver.
> 
> 

Applied to 5.16/scsi-queue, thanks!

[1/1] scsi_transport_sas: Add 22.5 link rate definitions
      https://git.kernel.org/mkp/scsi/c/3d8fa78ebd61

-- 
Martin K. Petersen	Oracle Linux Engineering
