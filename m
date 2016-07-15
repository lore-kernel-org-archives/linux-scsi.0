From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] mpt3sas: Fix panic when aer correct error occured
Date: Fri, 15 Jul 2016 15:09:24 -0400
Message-ID: <yq1twfqiuqj.fsf@sermon.lab.mkp.net>
References: <1468316605-788-1-git-send-email-wangkefeng.wang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47360 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbcGOTJj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jul 2016 15:09:39 -0400
In-Reply-To: <1468316605-788-1-git-send-email-wangkefeng.wang@huawei.com>
	(Kefeng Wang's message of "Tue, 12 Jul 2016 17:43:25 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: martin.petersen@oracle.com, suganath-prabu.subramani@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, guohanjun@huawei.com, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>

>>>>> "Kefeng" == Kefeng Wang <wangkefeng.wang@huawei.com> writes:

Kefeng> The _scsih_pci_mmio_enabled called if scsih_pci_error_detected
Kefeng> returns PCI_ERS_RESULT_CAN_RECOVER, at this point, read/write to
Kefeng> the device still works, no need to reset slot.

Applied to 4.8/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
