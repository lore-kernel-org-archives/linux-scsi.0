From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: Re: [PATCH] add SPI transport class to fusion
Date: Mon, 30 Jan 2006 21:42:54 -0700
Message-ID: <001b01c62620$cd8963a0$2c1015ac@ericmoore>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:40888 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1030232AbWAaEmt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jan 2006 23:42:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, hch@lst.de

I wrote:

> So for channel=0, for all target_ids equal to pIocPg3->PhysDisk[].PhysDiskID, then 
> `vdev->vtarget->tflags` equal to MPT_TARGET_FLAGS_RAID_COMPONENT , 
> and we set sdev->no_uld_attach = 1.  For non-raided devices on this
> channel, we set sdev->no_uld_attach = 0. 
> All queue_command request for hidden devices with tflags set for RAID_COMPONENT, 
> will be sent with function=MPI_FUNCTION_SCSI_IO_REQUEST.
> 
My mistake, I meant

All queue_command request for hidden devices with tflags set for RAID_COMPONENT, 
will be sent with function=MPI_FUNCTION_RAID_SCSI_IO_PASSTHROUGH


