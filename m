From: Olaf Hering <olh@suse.de>
Subject: Re: 100% repeatable way to send firewire out to lunch permanently on 2.6.8.1
Date: Sun, 24 Oct 2004 21:29:20 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041024192920.GA23516@suse.de>
References: <Pine.LNX.4.44.0409050434540.8779-100000@sasami.anime.net> <20041024144236.GA21793@suse.de> <1098629588.10908.23.camel@mulgrave> <20041024150051.GA21922@suse.de> <1098631356.10824.33.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:10208 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S261591AbUJXT3k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Oct 2004 15:29:40 -0400
Content-Disposition: inline
In-Reply-To: <1098631356.10824.33.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Dan Hollis <goemon@anime.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>, bcollins@debian.org, linux1394-devel@lists.sourceforge.net

 On Sun, Oct 24, James Bottomley wrote:

> The trace doesn't show any error handler activity at all.  Are there =
no
> messages in the log about offlining the device?  If not, it sounds li=
ke
> there's a problem somewhere in the firewire system.

How should sbp2_remove_device get rid of the device? It calls
scsi_remove_host, which calls scsi_remove_device, which sets the mode t=
o
SDEV_CANCEL, then calls to device_del. sr_do_ioctl expects SDEV_OFFLINE=
=2E

--=20
USB is for mice, FireWire is for men!

sUse lINUX ag, n=C3=9CRNBERG
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
