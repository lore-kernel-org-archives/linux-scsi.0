From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] SATA Transport Attributes
Date: Mon, 29 Mar 2004 17:16:27 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040330011626.GA8647@kroah.com>
References: <20040330004601.GE18948@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kroah.org ([65.200.24.183]:13251 "EHLO perch.kroah.org")
	by vger.kernel.org with ESMTP id S263380AbUC3BRf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Mar 2004 20:17:35 -0500
Content-Disposition: inline
In-Reply-To: <20040330004601.GE18948@localhost>
List-Id: linux-scsi@vger.kernel.org
To: Martin Hicks <mort@wildopensource.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, jgarzik@pobox.com, linux-scsi@vger.kernel.org, Jesse Barnes <jbarnes@sgi.com>, jeremy@sgi.com

On Mon, Mar 29, 2004 at 07:46:01PM -0500, Martin Hicks wrote:
> 
> Hello,
> 
> Here is a patch that introduces a Transport Attribute class for SATA
> devices.  The patch also includes an update to the Vitesse driver to use
> the transport attribute.
> 
> The only problem that I'm having right now is that sometimes I get
> a NULL pointer dereference in scsi_remove_device() when I rmmod sata_vsc.

There's a nasty sysfs "issue" right now that can cause this to happen.
See the thread about it on lkml for more details.  This might be causing
your oops.

thanks,

greg k-h
