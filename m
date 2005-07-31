From: Olaf Hering <olh@suse.de>
Subject: Re: 100% repeatable way to send firewire out to lunch permanently on 2.6.8.1
Date: Sun, 31 Jul 2005 21:16:58 +0200
Message-ID: <20050731191658.GC19681@suse.de>
References: <20041024192920.GA23516@suse.de> <Pine.LNX.4.44.0507310739320.13193-100000@sasami.anime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:46031 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S261919AbVGaTRE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 31 Jul 2005 15:17:04 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0507310739320.13193-100000@sasami.anime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Hollis <goemon@anime.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, bcollins@debian.org, linux1394-devel@lists.sourceforge.net

 On Sun, Jul 31, Dan Hollis wrote:

> On Sun, 24 Oct 2004, Olaf Hering wrote:
> >  On Sun, Oct 24, James Bottomley wrote:
> > > The trace doesn't show any error handler activity at all.  Are there no
> > > messages in the log about offlining the device?  If not, it sounds like
> > > there's a problem somewhere in the firewire system.
> > How should sbp2_remove_device get rid of the device? It calls
> > scsi_remove_host, which calls scsi_remove_device, which sets the mode to
> > SDEV_CANCEL, then calls to device_del. sr_do_ioctl expects SDEV_OFFLINE.
> 
> Has there been any progress on this issue? I just got my _entire scsi 
> subsystem_ sent out to lunch because a firewire device lost power.

I cant help you with that, sr_mod is likely still broken with MRW
capable drives. But sbp2 is still the culprit, incomplete error
handling.
