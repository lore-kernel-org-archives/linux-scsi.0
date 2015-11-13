From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH] mpt3sas: Fix use sas_is_tlr_enabled API before enabling
 MPI2_SCSIIO_CONTROL_TLR_ON flag
Date: Fri, 13 Nov 2015 16:05:28 +0100
Message-ID: <5645FC38.2070201@redhat.com>
References: <1447351837-31388-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932478AbbKMPFb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Nov 2015 10:05:31 -0500
In-Reply-To: <1447351837-31388-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>, jejb@kernel.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, chaitra.basappa@avagotech.com, suganath-prabu.subramani@avagotech.com

On 12.11.2015 19:10, Sreekanth Reddy wrote:
> Before enabling MPI2_SCSIIO_CONTROL_TLR_ON flag in MPI SCSI IO
> request message, check whether TLR is enabled on the drive using
> 'sas_is_tlr_enabled' API.
>
> Actually in the driver code, driver is using below API's
>
> 1. sas_enable_tlr() - to enable the TLR
> 2. sas_disable_tlr() - to disable the TLR
> 3. sas_is_tlr_enabled() - to check whether TLR is enabled or not.
>
> but in scsih_qcmd() we have missed to use sas_is_tlr_enabled() API,
> instead we checking for TLR bit from flag field of driver's
> 'struct MPT3SAS_DEVIC' structure. which is corrected with this patch.
>
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

