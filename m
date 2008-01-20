From: Greg KH <greg@kroah.com>
Subject: Re: PATCH: usb-storage-set-last-sector-bug-flag.patch
Date: Sun, 20 Jan 2008 12:56:25 -0800
Message-ID: <20080120205625.GB28842@kroah.com>
References: <47932211.90105@hhs.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:40389 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075AbYATUzi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Jan 2008 15:55:38 -0500
Content-Disposition: inline
In-Reply-To: <47932211.90105@hhs.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, USB development list <linux-usb-devel@lists.sourceforge.net>, David Brown <usb-storage2@davidb.org>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

On Sun, Jan 20, 2008 at 11:27:29AM +0100, Hans de Goede wrote:
> Hi all,
>
> This patch sets the last_sector_bug flag to 1 for all USB disks. This is
> needed to makes the cardreader on various HP multifunction printers work.
>
> Since the performance impact is negible we set this flag for all USB disks 
> to avoid an unusual_devs.h nightmare.

Oh great, now my "working just fine" USB devices, which happen to have
data in the last sector, suddenly stop working.

That's not acceptable :(

greg k-h
