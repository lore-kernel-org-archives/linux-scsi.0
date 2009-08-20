From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito-qczF+2RCDl1fyO9Q7EP/yw@public.gmane.org>
Subject: Re: [Bugme-new] [Bug 14020] New: Stack trace when running smartctl
 on an USB disk
Date: Thu, 20 Aug 2009 19:07:40 -0300
Message-ID: <20090820220740.GA767@ime.usp.br>
References: <bug-14020-10286@http.bugzilla.kernel.org/>
 <20090820145830.4f745fc3.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090820145830.4f745fc3.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org, bugme-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi, Andrew & Co.

On Aug 20 2009, Andrew Morton wrote:
> On Thu, 20 Aug 2009 02:13:27 GMT
> bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org wrote:
> > Trying to see the status of a drive of mine that is in an USB enclo=
sure, I
> > issued the command:
> >=20
> >   # smartctl -d usbcypress -a /dev/sda
> >=20
> > What I got in return was:
> >=20
> > "task smartctl:1513 blocked for more than 120 seconds" with a subse=
quent stack
> > trace, listed below.
>=20
> Yup, that's a bug.

Thanks for the confirmation.

> I assume that smartctl never recovered?

Yes, sorry for not mentioning this explicitly. smartctl hang there and
was uninterruptible. :-(

> I don't know if it's a scsi bug or a usb bug.  Probably the latter?

Again, just reiterating, what I said before, even though I am not sure
if I can reproduce it, I will try to.

And if any further information about my hardware is needed, please, jus=
t
let me know.


Thanks, Rog=C3=A9rio Brito.

--=20
Rog=C3=A9rio Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2C=
AEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
