From: Greg KH <greg@kroah.com>
Subject: Re: [linux-usb-devel] oops on usb storage device disconnect with 2.6.14-rc1
Date: Sun, 18 Sep 2005 15:01:26 -0700
Message-ID: <20050918220126.GA6317@kroah.com>
References: <20050915190338.GA6807@kroah.com> <Pine.LNX.4.44L0.0509151514460.4493-100000@iolanthe.rowland.org> <20050915192912.GA7077@kroah.com> <1126814226.4821.48.camel@mulgrave> <1126818483.4821.60.camel@mulgrave> <20050915221946.GA28441@us.ibm.com> <1126823917.4821.70.camel@mulgrave> <1127003717.4794.10.camel@mulgrave> <1127073920.4847.34.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kroah.org ([69.55.234.183]:39908 "EHLO perch.kroah.org")
	by vger.kernel.org with ESMTP id S932208AbVIRWCU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Sep 2005 18:02:20 -0400
Content-Disposition: inline
In-Reply-To: <1127073920.4847.34.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, Alan Stern <stern@rowland.harvard.edu>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdharm-usb@one-eyed-alien.net

On Sun, Sep 18, 2005 at 03:05:20PM -0500, James Bottomley wrote:
> On Sat, 2005-09-17 at 19:35 -0500, James Bottomley wrote:
> > The attached should be that patch with the race window closed.
> 
> There's a big oops in this one (and there was when greg tested it).  The
> state checker is reversed (it's checking !scsi_host_set_state() for
> indicating a problem ... of course, the return is 0 on success or
> error).  I've corrected this; Greg, could you retest? 

Should I apply any additional patches too?  Or just this one will
suffice?

thanks,

greg k-h
