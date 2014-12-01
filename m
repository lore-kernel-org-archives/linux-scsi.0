From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] usb: storage: debug: uninitialized var in
 usb_stor_show_sense()
Date: Mon, 1 Dec 2014 13:42:46 +0300
Message-ID: <20141201104246.GD4994@mwanda>
References: <20141129124801.GA27251@mwanda>
 <1417277275.2202.35.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1417277275.2202.35.camel@HansenPartnership.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Hannes Reinecke <hare@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, =?iso-8859-1?Q?J=F6rn?= Engel <joern@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, Nov 29, 2014 at 08:07:55AM -0800, James Bottomley wrote:
> On Sat, 2014-11-29 at 15:48 +0300, Dan Carpenter wrote:
> > The "fmt" variable might be used uninitialized, it should be set to NULL
> > at the start.
> > 
> > Fixes: d811b848ebb7 ('scsi: use sdev as argument for sense code printing')
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> Hm, that' falls into the category of an interface that's hard to get
> right if every caller has to remember to set fmt to NULL.
> 
> Could you instead set *fmt to NULL in scsi_extd_sense_format()?  That
> way the interface is much easier.
> 

Sure.  I will send that tomorrow.

regards,
dan carpenter

