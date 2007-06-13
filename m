From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [patch 0/3] AHCI Link Power Management
Date: Wed, 13 Jun 2007 09:26:07 -0700
Message-ID: <20070613092607.4ddf0f79.kristen.c.accardi@intel.com>
References: <20070611114600.7fca1c24.kristen.c.accardi@intel.com>
	<466DFDB5.9030901@gmail.com>
	<466E0642.5020506@linux.intel.com>
	<466E1D51.9070007@gmail.com>
	<20070613090430.GK13747@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:22087 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758786AbXFMQ3e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jun 2007 12:29:34 -0400
In-Reply-To: <20070613090430.GK13747@elf.ucw.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: Tejun Heo <htejun@gmail.com>, Arjan van de Ven <arjan@linux.intel.com>, jeff@garzik.org, james.bottomley@steeleye.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>

On Wed, 13 Jun 2007 11:04:30 +0200
Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
> 
> > >> I'm not sure about this.  We need better PM framework to support 
> > >> powersaving in other controllers and some ahcis don't save much
> > >> when only link power management is used,
> > > 
> > > do you have data to support this?
> > 
> > Yeah, it was some Lenovo notebook.  Pavel is more familiar with the
> > hardware.  Pavel, what was the notebook which didn't save much power
> > with standard SATA power save but needed port to be completely turned off?
> 
> Thinkpad x60. Some one Kristen probably used while developing the
> patch :-).

Yes - that confirms my conclusion that the first patch just wasn't
done correctly - cause when I measure the power savings with a power
meter on the X60 with my patches I see ~ 1W.
