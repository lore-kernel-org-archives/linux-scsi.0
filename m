From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] zfcp: kfree patch
Date: Sun, 9 Jan 2005 23:06:39 -0800
Message-ID: <20050110070639.GC13078@kroah.com>
References: <20050108223326.GB3415@kroah.com> <OF3362DD9E.0CC252EE-ONC1256F85.0024CE6A-C1256F85.0025CDCC@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kroah.org ([69.55.234.183]:51427 "EHLO perch.kroah.org")
	by vger.kernel.org with ESMTP id S262122AbVAJHGt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jan 2005 02:06:49 -0500
Content-Disposition: inline
In-Reply-To: <OF3362DD9E.0CC252EE-ONC1256F85.0024CE6A-C1256F85.0025CDCC@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Heiko Carstens <Heiko.Carstens@de.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Jan 10, 2005 at 07:53:19AM +0100, Heiko Carstens wrote:
> > > this is my next attempt to try to get the patch below merged. Last
> > > time Greg KH objected and it didn't get merged.
> > 
> > As nothing has changed in the patch, I still object to it.  Actually,
> > krefs will BUG() out if you try to do this, so I might as well add a
> > patch so that kobjects do the same thing...
> 
> So what's the fix for this generic (non-zfcp specific) problem then?

As no other code uses this type of "solution" I don't see how you can
say it is "generic".
