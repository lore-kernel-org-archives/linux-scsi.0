From: Linus Torvalds <torvalds@transmeta.com>
Subject: Re: [PATCH] /proc/scsi/map
Date: Thu, 20 Jun 2002 14:04:23 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0206201401010.8225-100000@home.transmeta.com>
References: <3D124149.6010901@evision-ventures.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3D124149.6010901@evision-ventures.com>
List-Id: linux-scsi@vger.kernel.org
To: Martin Dalecki <dalecki@evision-ventures.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Kurt Garloff <garloff@suse.de>, Linux kernel list <linux-kernel@vger.kernel.org>, Linux SCSI list <linux-scsi@vger.kernel.org>



On Thu, 20 Jun 2002, Martin Dalecki wrote:
> >
> > 	/devices/disks/disk0 -> ../../pci0/00:02.0/02:1f.0/03:07.0/disk0
>                   ^^^^^^^^^^ You notice the redundancy in naming here :-).

I'd rather have redundancy than have horrible names like just "0", thank
you very much.

It takes up no space, all the dentries are virtual anyway, and a dentry
embeds the storage for the first n characters (n ~16 or something like
that).

> Boah the chierachies are already deep enough. /devices/net/eth@XX
> will cut it.

There is _no_ excuse for being terse.

Also, never EVER use special characters like "@" unless there is _reason_
to use them. I don't see any reason to make a filesystem look like perl.

Please use sane names like "disknnn" over insane cryptographically secure
filesystem contents like "sd@nnn".

		Linus

