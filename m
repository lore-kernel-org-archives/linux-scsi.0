From: Oliver Neukum <oliver@neukum.name>
Subject: Re: Re: [PATCH] USB changes for 2.5.58
Date: Fri, 24 Jan 2003 17:06:56 +0100
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <200301241706.56152.oliver@neukum.name>
References: <Pine.LNX.4.44L0.0301241026060.821-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.44L0.0301241026060.821-100000@ida.rowland.org>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Doug Ledford <dledford@redhat.com>, Luben Tuikov <luben@splentec.com>, David Brownell <david-b@pacbell.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


> Matt's current proposed patch has the USB LLDD calling
> scsi_unregister_host()  (because the device is respresented as an emula=
ted
> host adapter) when it learns that the device is gone.  Provided that
> routine doesn't block for very long, provided it handles all the detail=
s
> of hotplug notifications, and provided it guarantees that after it retu=
rns
> there will be no more calls to the emulated adapter, I don't see any
> problem.  The LLDD can go ahead and remove all records of the former
> device, secure in the knowledge that all pointers to data structures an=
d
> entry points have been erased.
>
> Isn't this exactly what everyone has been asking for and debating about=
?

If it only met the requirements, we'd be happy.
But it doesn't. By a large margin.

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
