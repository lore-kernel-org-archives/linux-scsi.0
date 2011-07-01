From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] USB: fix regression occurring during device removal
Date: Fri, 1 Jul 2011 23:04:02 +0200
Message-ID: <20110701210402.GG23059@one.firstfloor.org>
References: <1309552148.2722.46.camel@mulgrave> <Pine.LNX.4.44L0.1107011640300.1624-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1107011640300.1624-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Dave Jones <davej@redhat.com>, Andi Kleen <andi@firstfloor.org>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>, axboe@kernel.dk, "Rafael J. Wysocki" <rjw@sisk.pl>, USB list <linux-usb@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> This should fix the problem.  Or at least, it does fix a very similar 
> problem.

Thanks. I tried it and it doesn't fix the problem unfortunately.

-Andi
