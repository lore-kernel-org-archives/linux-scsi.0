From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 1/2] cciss: cleans up warnings in the 32/64 bit
	conversions
Date: 24 Oct 2004 11:54:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1098633262.10824.35.camel@mulgrave>
References: <20041021211718.GA10462@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:13736 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261543AbUJXPye (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Oct 2004 11:54:34 -0400
In-Reply-To: <20041021211718.GA10462@beardog.cca.cpqcorp.net>
List-Id: linux-scsi@vger.kernel.org
To: mikem@beardog.cca.cpqcorp.net
Cc: marcelo.tosatti@cyclades.com, Jens Axboe <axboe@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-10-21 at 17:17, mike.miller@hp.com wrote:
> Patch 1 of 2 for 20041021.
> This patch cleans up some warnings in the 32-bit to 64-bit conversions.
> Please consider this for inclusion. Built against 2.4.28-pre4.
> Please apply in order.

There's something wrong with this patch (it might be a missing prior
patch) that's causing it to reject comprehensively.

> -typedef long (*handler_type) (unsigned int, unsigned int, unsigned long,
> +typedef int (*handler_type) (unsigned int, unsigned int, unsigned long,

Things like this.  handler_type has always been int not long in the
source that's currently in the tree.

James


