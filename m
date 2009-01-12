From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] iscsi: Kconfig option for debug prints.
Date: Mon, 12 Jan 2009 17:38:07 +0200
Message-ID: <496B63DF.6010602@panasas.com>
References: <496B62B8.3030402@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:10470 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752295AbZALPiL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jan 2009 10:38:11 -0500
In-Reply-To: <496B62B8.3030402@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: open-iscsi@googlegroups.com, linux-scsi <linux-scsi@vger.kernel.org>

Boaz Harrosh wrote:
> 
> Remove the dark ages /* define debug_print */ in code, to use
> a Kconfig option. With a system like Kconfig, in code, commented out,
> configuration options are slavery and hard work.
> (version control, manual edit ... need I say more)
> 
> I've used an "int" config bit-mask so more areas of code can be
> selected with one Koption, but mainly so that allmodconfig will
> not turn it on.
> 
> bit-1 - will turn on prints for libiscsi.
> bit-2 - will turn on prints for libiscsi_tcp & iscsi_tcp.
> 
> More iscsi drivers should use more bits.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---
>  drivers/scsi/Kconfig        |   15 +++++++++++++++
>  drivers/scsi/iscsi_tcp.c    |    7 -------
>  drivers/scsi/iscsi_tcp.h    |    6 ++++++
>  drivers/scsi/libiscsi_tcp.c |    7 -------
>  include/scsi/libiscsi.h     |    3 +--
>  5 files changed, 22 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig

Mike hi.

These are over latest Linus. Sorry I mixed up the branches.
If they don't apply to your tree any more, I'll rebase.

I'm sending these because for too many times I submit some code
with iscsi sources edits, because I forget to remove the edits
for enabling prints. Please consider for inclusion.

Thanks
Boaz
