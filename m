From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was:
 ehci_hcd fails to read a single good block)
Date: Mon, 16 Apr 2012 11:06:14 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1204161103080.1408-100000@iolanthe.rowland.org>
References: <344714.25777.qm@web100012.mail.kks.yahoo.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <344714.25777.qm-W9a5FxB6bg85iCj6gykswkyFvBl6snHEEwWAM/ix52Y@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Norman Diamond <n0diamond-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 16 Apr 2012, Norman Diamond wrote:

> Alan Stern wrote:
> > On Fri, 13 Apr 2012, Norman Diamond wrote:
> >> You THOUGHT you knew in advance that a particular bridge is known
> >> to have the overreporting but, where in fact in some secret
> >> revisions it doesn't and in some secret revisions we're not quite
> >> sure, missing a log and missing a test sample for further
> >> testing.=A0 How can we be sure that other bridge manufacturers don=
't
> >> also make secret revisions?
> >=20
> > In fact we don't know.=A0 But that's not a good enough reason to ri=
sk
> > breaking existing systems.=A0 When we encounter bridges whose
> > behavior has changed, we can update the quirk entries.
>=20
> That's not a good enough reason to cause known breakage in newer
> existing systems, but I agree that updating the quirk entries helps
> solve it.
>=20
> > (Even that isn't as cautious as I'd like.=A0 If the device behavior
> > has changed then maybe the old devices won't handle reading beyond
> > the end of the drive.=A0 But I can't think of anything safer.)
>=20
> Well, if the reported capacity isn't a multiple of 63 and if no
> existing partition includes the last reported block then it seems
> comparatively safe to decrement the reported size, but as you pointed
> out, we can't really be sure what the existing partitions are
> (non-DOS tables etc.).  But a multiple of 63 still seems like a
> relatively safe heuristic, comparatively speaking.  But not always,
> as you pointed out, and as I'll detail below.

At this point I'm not sure what you want to do.  Would you like the=20
quirks entry for your bridge changed to CAPACITY_HEURISTICS instead of=20
=46IX_CAPACITY?  That's the easiest thing to do quickly.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
