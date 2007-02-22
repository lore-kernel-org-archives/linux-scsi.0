From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Patch 2/2] cciss: add shutdown support (replaces reboot
	notifier)
Date: Thu, 22 Feb 2007 15:49:38 -0600
Message-ID: <1172180978.3378.35.camel@mulgrave.il.steeleye.com>
References: <20070222213845.GA14162@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:45364 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751903AbXBVVut (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Feb 2007 16:50:49 -0500
In-Reply-To: <20070222213845.GA14162@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: akpm@osdl.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, gregkh@novell.com, hch@infradead.org

On Thu, 2007-02-22 at 15:38 -0600, Mike Miller (OS Dev) wrote:
>         .remove = __devexit_p(cciss_remove_one),
>         .id_table = cciss_pci_device_id,        /* id_table */
> +       .shutdown = cciss_remove_one,

You need a __devexit_p() wrapper for this one too.

James


