From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] usb-storage: implement autosuspend
Date: Wed, 28 Jul 2010 21:16:25 +0000
Message-ID: <1280351785.30808.603.camel@mulgrave.site>
References: <Pine.LNX.4.44L0.1007281702030.1744-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56520 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959Ab0G1VQe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jul 2010 17:16:34 -0400
In-Reply-To: <Pine.LNX.4.44L0.1007281702030.1744-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Oliver Neukum <oliver@neukum.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

On Wed, 2010-07-28 at 17:12 -0400, Alan Stern wrote:
> Because this patch depends on those SCSI changes, either it should also 
> go via James's tree or else the SCSI patches should be imported into 
> Greg's tree first.  James and Greg, which route is easier for you?

They're USB patches, so they should be in a USB tree.  Just do a
standard postmerge tree based on SCSI.

James


