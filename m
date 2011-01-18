From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH 0/10] mpt2sas: Description Patch
Date: Tue, 18 Jan 2011 23:59:26 +0530
Message-ID: <B2FD678A64EAAD45B089B123FDFC3ED7091C6F5B@inbmail01.lsi.com>
References: <20110104060032.GA5751@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:45969 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752495Ab1ARS3G convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2011 13:29:06 -0500
In-Reply-To: <20110104060032.GA5751@lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

James,

Any feedback on this patch set. ? 

Thanks, Kashyap

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Kashyap, Desai
> Sent: Tuesday, January 04, 2011 11:31 AM
> To: linux-scsi@vger.kernel.org
> Cc: James.Bottomley@HansenPartnership.com; Moore, Eric; Prakash, Sathya
> Subject: [PATCH 0/10] mpt2sas: Description Patch
> 
> 
> MPT2SAS driver changes.
> These patches are taken from 2.6.37-rc5.
> Please consider this patch set for next kernel release.
> 
> [PATCH 01/10] mpt2sas: Device removal handshake even though the
> PHYSTATUS_VACANT bit is set in the PhyStatus
> [PATCH 02/10] mpt2sas: Internal device reset complete event is not
> supported for older firmware prior to MPI Rev K
> [PATCH 03/10] mpt2sas: Correct resizing calculation for max_queue_depth
> [PATCH 04/10] mpt2sas: Revision P MPI Header Update
> [PATCH 05/10] mpt2sas: Add support for Customer specific branding
> messages
> [PATCH 06/10] mpt2sas: Fix the race between broadcast asyn event and
> scsi
> command completion.
> [PATCH 07/10] mpt2sas: Prevent access to freed memory from port enable
> process
> [PATCH 08/10] mpt2sas: Basic Code Cleanup in mpt2sas_base
> [PATCH 09/10] mpt2sas: Call the _scsih_ir_shutdown prior to reporting
> the
> volumes missing from the OS
> [PATCH 10/10] mpt2sas: Bump version 08.100.00.00
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
> ---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
