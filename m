From: Oliver Neukum <oliver@neukum.name>
Subject: Re: Re: [PATCH] USB changes for 2.5.58
Date: Tue, 21 Jan 2003 08:17:12 +0100
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <200301210817.12096.oliver@neukum.name>
References: <10426732153816@kroah.com> <200301201923.50467.oliver@neukum.name> <1043119913.13397.14.camel@dhcp22.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <1043119913.13397.14.camel@dhcp22.swansea.linux.org.uk>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: Luben Tuikov <luben@splentec.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Am Dienstag, 21. Januar 2003 04:31 schrieb Alan:
> On Mon, 2003-01-20 at 18:23, Oliver Neukum wrote:
> > > The transport can notify that the device is gone, but an ULP entity
> > > will call scsi_remove_device() not the other way around.
> >
> > NO!
> >
> > This is an insanely complicated scheme.
> > We have no notification beforehand. User yanks out cable.
> > That's it. No preperation at all.
> >
> > We as the writers of device drivers need a way to get rid of the devi=
ce
> > as we are notified of the physical disconnect. It is not our job to
> > maintain devices in an undead state.
>
> If you think about it rationally there isnt a lot that can be done high=
er
> up. At the point the hardware vanishes there may be other threads of
> execution already in your driver, so undead state is a reality you have=
 to
> live with, at least briefly.

No problem with that. I have a problem with notifying the SCSI layer
and then waiting for an unlimited time until maybe the SCSI layer decides
to inform me of a success. You see, disconnection has to work.
Having to wait for an unlimited time is a kind of failure.

I simply don't trust the SCSI layer. I've had to much trouble with it
already.

=09Regards
=09=09Oliver



-------------------------------------------------------
This SF.NET email is sponsored by:
SourceForge Enterprise Edition + IBM + LinuxWorld = Something 2 See!
http://www.vasoftware.com
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
