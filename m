From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] PCI/MSI: Only disable affinity settings if pre and post vector count is equal to max_vecs and not min_vecs
Date: Wed, 22 Feb 2017 19:27:16 -0500
Message-ID: <yq11sup92fv.fsf@oracle.com>
References: <1487698473-4171-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39990 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934279AbdBWA10 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2017 19:27:26 -0500
In-Reply-To: <1487698473-4171-1-git-send-email-himanshu.madhani@cavium.com>
        (Himanshu Madhani's message of "Tue, 21 Feb 2017 09:34:33 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org

>>>>> "Himanshu" == Himanshu Madhani <himanshu.madhani@cavium.com> writes:

Himanshu,

Himanshu> min_vecs is the minimum amount of vectors needed to operate in
Himanshu> MSI-X mode which may just include the vectors that don't need
Himanshu> affinity.

Himanshu> Disabling affinity settings causes the qla2xxx driver
Himanshu> scsi_add_host to fail when blk_mq is enabled as the
Himanshu> blk_mq_pci_map_queues expects affinity masks on each vector.

Himanshu> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c index
[...]

This should go through the PCI tree and not SCSI.

-- 
Martin K. Petersen	Oracle Linux Engineering
