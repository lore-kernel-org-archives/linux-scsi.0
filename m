From: Dan Hollis <goemon@anime.net>
Subject: Re: 100% repeatable way to send firewire out to lunch permanently
 on 2.6.8.1
Date: Sun, 31 Jul 2005 07:43:11 -0700 (PDT)
Message-ID: <Pine.LNX.4.44.0507310739320.13193-100000@sasami.anime.net>
References: <20041024192920.GA23516@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sasami.anime.net ([207.109.251.120]:40335 "EHLO
	sasami.anime.net") by vger.kernel.org with ESMTP id S261618AbVGaOnV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 31 Jul 2005 10:43:21 -0400
In-Reply-To: <20041024192920.GA23516@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olh@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, bcollins@debian.org, linux1394-devel@lists.sourceforge.net

On Sun, 24 Oct 2004, Olaf Hering wrote:
>  On Sun, Oct 24, James Bottomley wrote:
> > The trace doesn't show any error handler activity at all.  Are there no
> > messages in the log about offlining the device?  If not, it sounds like
> > there's a problem somewhere in the firewire system.
> How should sbp2_remove_device get rid of the device? It calls
> scsi_remove_host, which calls scsi_remove_device, which sets the mode to
> SDEV_CANCEL, then calls to device_del. sr_do_ioctl expects SDEV_OFFLINE.

Has there been any progress on this issue? I just got my _entire scsi 
subsystem_ sent out to lunch because a firewire device lost power.

-Dan

