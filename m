From: Greg KH <gregkh@suse.de>
Subject: Re: [RFC 22/22] tcm_loop: Add multi-fabric Linux/SCSI LLD fabric
	module
Date: Mon, 6 Sep 2010 13:34:19 -0700
Message-ID: <20100906203419.GF5162@suse.de>
References: <20100905203006.GD18411@core.coreip.homeip.net> <1283723479.556.135.camel@haakon2.linux-iscsi.org> <20100906050816.GD17212@core.coreip.homeip.net> <20100906051703.GA2891@suse.de> <1283750480.556.196.camel@haakon2.linux-iscsi.org> <20100906053845.GG17212@core.coreip.homeip.net> <1283752861.556.200.camel@haakon2.linux-iscsi.org> <20100906062625.GI17212@core.coreip.homeip.net> <AANLkTimhHt78GFbxxjy1tosmebMVg-vKCNoJuqVa+iLH@mail.gmail.com> <20100906194446.GA31384@core.coreip.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37479 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755411Ab0IFUuT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Sep 2010 16:50:19 -0400
Content-Disposition: inline
In-Reply-To: <20100906194446.GA31384@core.coreip.homeip.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Richard Sharpe <realrichardsharpe@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>

On Mon, Sep 06, 2010 at 12:44:46PM -0700, Dmitry Torokhov wrote:
> Yes, that is the one. I'll blame Greg for inconsistent naming that
> caused this error :) - we usually have xxx_register() for objects that
> we already have on hand and xxx_create() (as in device_create) when we
> want the object to be allocated for us.

Yes, we have a number of naming inconsistancies in the driver core like
this.  I need to sit down and fix them all one of these days...

thanks,

greg k-h
