From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] zfcp: kfree patch
Date: Sat, 8 Jan 2005 14:33:26 -0800
Message-ID: <20050108223326.GB3415@kroah.com>
References: <20050108103641.GA8018@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kroah.org ([69.55.234.183]:26314 "EHLO perch.kroah.org")
	by vger.kernel.org with ESMTP id S261233AbVAHWmp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Jan 2005 17:42:45 -0500
Content-Disposition: inline
In-Reply-To: <20050108103641.GA8018@osiris.boeblingen.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, Jan 08, 2005 at 11:36:41AM +0100, Heiko Carstens wrote:
> Hi James,
> 
> this is my next attempt to try to get the patch below merged. Last
> time Greg KH objected and it didn't get merged.

As nothing has changed in the patch, I still object to it.  Actually,
krefs will BUG() out if you try to do this, so I might as well add a
patch so that kobjects do the same thing...

sorry,

greg k-h
