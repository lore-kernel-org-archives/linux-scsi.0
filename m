From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] zfcp: kfree patch
Date: Mon, 10 Jan 2005 00:18:15 -0800
Message-ID: <20050110081815.GA13612@kroah.com>
References: <20050110070639.GC13078@kroah.com> <OF21502B2A.CFA7983A-ONC1256F85.002AC44A-C1256F85.002CDDA7@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kroah.org ([69.55.234.183]:44690 "EHLO perch.kroah.org")
	by vger.kernel.org with ESMTP id S262142AbVAJISe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jan 2005 03:18:34 -0500
Content-Disposition: inline
In-Reply-To: <OF21502B2A.CFA7983A-ONC1256F85.002AC44A-C1256F85.002CDDA7@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Heiko Carstens <Heiko.Carstens@de.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Jan 10, 2005 at 09:10:21AM +0100, Heiko Carstens wrote:
> > > > As nothing has changed in the patch, I still object to it. Actually,
> > > > krefs will BUG() out if you try to do this, so I might as well add a
> > > > patch so that kobjects do the same thing...
> > > So what's the fix for this generic (non-zfcp specific) problem then?
> > As no other code uses this type of "solution" I don't see how you can
> > say it is "generic".
> 
> Since you still don't like the patch I would like to know how it should
> look like that you would accept it.

As I don't know the scsi subsystem, I can only rely on the fact that
kfree should never be used as a release call.  So fix that, and I'm
happy :)

> Also in my original post I described what the problem is. If that problem
> exists then it is generic.
> Please see also "Module unloading in a reference counted world"
> -> http://lwn.net/Articles/67421/

I understand the "generic" issue, however no other subsystem needs to
use kfree as a release call.  Now either everyone else is broken or...

thanks,

greg k-h
