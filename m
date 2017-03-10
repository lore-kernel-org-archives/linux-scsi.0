From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 1/4] megaraid_sas: enable intx only if msix request fails
Date: Fri, 10 Mar 2017 17:00:05 +0100
Message-ID: <b7e56745-a732-4de4-9b10-bde07e36d557@redhat.com>
References: <1489144935-26567-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1489144935-26567-2-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38890 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755387AbdCJQAS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 10 Mar 2017 11:00:18 -0500
In-Reply-To: <1489144935-26567-2-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com

On 10.3.2017 12:22, Shivasharan S wrote:
> Without this fix, driver will enable INTx Interrupt pin even though
> MSI-x vectors are enabled. See below lspci output. DisINTx is unset
> for MSIx setup.
>
> lspci -s 85:00.0 -vvv |grep INT |grep Control
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
>
> After applying this fix, driver will enable INTx Interrupt pin only
> if Legacy interrupt method is required.
> See below lspci output. DisINTx is set for MSIx setup.
> lspci -s 85:00.0 -vvv |grep INT |grep Control
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx+
>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>
tomash
