From: Oliver Neukum <oliver@neukum.name>
Subject: Re: [linux-usb-devel] Re: /proc/scsi/map
Date: Sun, 16 Jun 2002 22:54:42 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200206162254.42323.oliver@neukum.name>
References: <200206161725.g5GHP6S23020@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200206161725.g5GHP6S23020@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, David Brownell <david-b@pacbell.net>
Cc: Andries.Brouwer@cwi.nl, garloff@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, sancho@dauskardt.de, linux-usb-devel@lists.sourceforge.net, linux1394-devel@lists.sourceforge.net, dougg@torque.net

Am Sonntag, 16. Juni 2002 19:25 schrieb James Bottomley:
> Since we already have a huge long list of different ways to identify
> different devices, I don't think coding any one or even a set of such
> methods into the kernel would satisfy everyone.
>
> What about a different approach:
>
> We already (nearly) have the scsimon patches to do hot plug events on
> SCSI devices incorporated.  Any identification could be done from the
> scsi device hotplug script (i.e. if you see it's USB, get the GID, if
> it's enterprise storage get the WWN, try the filesystem UUID etc).  Then
> all the hotplug script does is plug this device into some type of volume
> idenfication scheme like /dev/volume/<name>.

How would you find out what a device is ?
If the kernel has to supply the information anyway, you could
just as well pass all information to the script or devfs.

	Regards
		Oliver

