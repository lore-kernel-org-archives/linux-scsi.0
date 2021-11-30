Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9744DC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 04:37:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232889AbhK3ElK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Nov 2021 23:41:10 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:6972 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232820AbhK3ElJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Nov 2021 23:41:09 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AU2o7al020991;
        Tue, 30 Nov 2021 04:37:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=fkYQlCLBfNGDonYTlHHCEGIYNE1P0+RMHsYrKFkkEW4=;
 b=P4XjIBZDQDQoUbqVAa/+09od1DI62HiA3W7mgFEkjjBoI6u95znUVdB3nuOG1F6kRoRB
 uaCks4ducXOTA1tK96ai8H6VXXmL8XTsuGXpUe1IBaFaBK3QneYZuBd4auOj7sfYNDUm
 6LPdEDx5w/aVzGqInkemM0SrF9zwnh7PqhLwRpk/cI7/B1SsjNhLJK1PE8P9or/lp/6T
 nesp/85k2ox9WnygcuypRm6N8IvlSsyzSlg4+RkXidqOMDKYRgVWCs2g1GKqAfRlk9Wp
 kSABjPXBWbJ/9OeWH18GRySWoWukl6gaixDntnrGaOsWq6KxtwBvkwuQYywu0ZZLy0Ik eQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cmvmwpd1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Nov 2021 04:37:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AU4ZbmB145768;
        Tue, 30 Nov 2021 04:37:48 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3ckaqe0p2j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Nov 2021 04:37:48 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1AU4blLa152494;
        Tue, 30 Nov 2021 04:37:47 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3ckaqe0p2c-1;
        Tue, 30 Nov 2021 04:37:47 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Bean Huo <huobean@gmail.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH V2] scsi: ufs: ufs-pci: Add support for Intel ADL
Date:   Mon, 29 Nov 2021 23:37:45 -0500
Message-Id: <163824680188.31422.1766139354889695358.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211124204218.1784559-1-adrian.hunter@intel.com>
References: <20211124204218.1784559-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: nZbRHhLZJ2zidA4chOKDGIQix-D1uxuo
X-Proofpoint-GUID: nZbRHhLZJ2zidA4chOKDGIQix-D1uxuo
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 24 Nov 2021 22:42:18 +0200, Adrian Hunter wrote:

> Add PCI ID and callbacks to support Intel Alder Lake.
> 
> 

Applied to 5.16/scsi-fixes, thanks!

[1/1] scsi: ufs: ufs-pci: Add support for Intel ADL
      https://git.kernel.org/mkp/scsi/c/7dc9fb47bc9a

-- 
Martin K. Petersen	Oracle Linux Engineering
