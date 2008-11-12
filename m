From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC 0/12] mpt2sas - new device driver
Date: Wed, 12 Nov 2008 12:06:20 -0800
Message-ID: <1226520380.3528.14.camel@localhost.localdomain>
References: <20081103083358.GA3337@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37565 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752843AbYKMAB6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Nov 2008 19:01:58 -0500
In-Reply-To: <20081103083358.GA3337@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <eric.moore@lsi.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2008-11-03 at 01:34 -0700, Eric Moore wrote:
> * Here is first draft of mpt2sas for your review and comment. 
>   This is new scsi lld device driver supporting the SAS 2.0 standard.
>   This driver source sits in the scsi-ml tree.	
>   (We went with new device driver due to major changes in the driver-firmware transport interface)
> 
> * Here is list of new 6gb host controllers:
> 
>   LSI SAS2004 - Spitfire
>   LSI SAS2008 - Falcon
>   LSI SAS2108 - Liberator
>   LSI SAS2116 - Meteor
> 
> * Here is a summary of the patchs:
> 
> [PATCH 1/12] mpt2sas_base.c - Common API layer interface to MPT (Message Passing Technology) firmware.
> [PATCH 2/12] mpt2sas_config.c - Common API for accessing firmware configuration pages.
> [PATCH 3/12] mptsas_ctl.[c,h] - Storage Management Module.
> [PATCH 4/12] mpt2sas_scsih.c - SCSI Host Layer.
> [PATCH 5/12] mpt2sas_transport.c - Common API for accessing the Kernel SAS Transport Layer.
> [PATCH 6/12] mpt2sas_base.h - Header shared structs.
> [PATCH 7/12] mpt2sas_debug.h - Header for debug logging.

This patch apparently didn't make the list, could you resend?

> [PATCH 8/12] mptsas/mpi/* -  Common MPI (Message Passing Interface) Headers.
> [PATCH 9/12] Kconfig: Kernel configuration file.
> [PATCH 10/12] Makefile - Driver Makefile
> [PATCH 11/12] Kconfig, scsi-ml - Adding mptsas.
> [PATCH 12/12] linux/miscdevice.h - Adding suport for MPT2SAS_MINOR

Thanks,

James


