From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 09/30] drivers/scsi/mca_53c9x.c : save_flags()/cli()
	removal
Date: Mon, 07 May 2007 14:56:38 -0500
Message-ID: <1178567798.3729.48.camel@mulgrave.il.steeleye.com>
References: <200704260735.l3Q7ZExL024232@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:43352 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754839AbXEGT4y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 May 2007 15:56:54 -0400
In-Reply-To: <200704260735.l3Q7ZExL024232@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, amol@verismonetworks.com, alan@lxorguk.ukuu.org.uk

On Thu, 2007-04-26 at 00:35 -0700, akpm@linux-foundation.org wrote:
> From: Amol Lad <amol@verismonetworks.com>
> 
> Replaced save_flags()/cli() with spin_lock alternatives

This one, there's not much point to ... the driver now needs to be
converted correctly over to esp_scsi.

James


