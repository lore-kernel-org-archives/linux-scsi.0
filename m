From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: Re: [PATCH v2 0/4] qla2xxx: Add FC-NVMe Target support
Date: Thu, 9 Nov 2017 20:06:01 -0800 (PST)
Message-ID: <alpine.OSX.2.21.1711092004500.44710@n5102mv83lvdv1.qlogic.org>
References: <20171109031754.10270-1-himanshu.madhani@cavium.com> <20171109093321.GA17246@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0087.outbound.protection.outlook.com ([104.47.33.87]:37469
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751709AbdKJEGJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 9 Nov 2017 23:06:09 -0500
In-Reply-To: <20171109093321.GA17246@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-nvme@lists.infradead.org, sagi@grimberg.me, james.smart@broadcom.com, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org



On Thu, 9 Nov 2017, 1:33am, Christoph Hellwig wrote:

> Before even looking at the patches:  they seem to add a lot of new
> sparse warnings, mostly about endianess issues.  Given that FC-NVMe
> is a mix of BE and LE structures getting this right is important.
> Please fix them up first.
> 
> 
> 

Sure, will fix up endianess warnings and resubmit patches.

Thanks,
Himanshu
