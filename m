From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: /dev/[*]st* does not work with EXBAYTE 8505 with 2.6 kernels
Date: Wed, 25 Aug 2004 22:33:19 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0408252225550.1974@kai.makisara.local>
References: <412C315D.1000708@hovedpuden.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep31-0.kolumbus.fi ([193.229.0.35]:63041 "EHLO
	fep31-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S268365AbUHYTdV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Aug 2004 15:33:21 -0400
In-Reply-To: <412C315D.1000708@hovedpuden.dk>
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?John_Damm_S=F8rensen?= <john@hovedpuden.dk>
Cc: linux-scsi@vger.kernel.org

I am moving this thread to linux-scsi where it belongs.

On Wed, 25 Aug 2004, John Damm S=F8rensen wrote:

> I have just upgraded from RH9 Linux 2.4 to FC2 Linux 2.6 and now my
> EXABYTE 8505 no longer works.
>=20
> If I try to access it with mt (using any device like nst0) I get no s=
uch
> device error message. Same thing with stinit.
>=20
This suggests that the st driver has not found your drive. Your tape dr=
ive=20
is recognized as a sequential-access device and lsmod shows that st is=20
loaded. Puzzling.

If you look at the kernel messages, do you see something like this:

st: Version 20040403, fixed bufsize 32768, s/g segs 256
Attached scsi tape st0 at scsi0, channel 0, id 5, lun 0
st0: try direct i/o: yes (alignment 512 B), max page reachable by HBA=20
268435455

Another thing to check is /sys/class/scsi_tape/. You should see these=20
files: nst0  nst0a  nst0l  nst0m  st0  st0a  st0l  st0m

=2E..
> Any hints?
> Please don't tell me that the 8505 is no longer supported.
>=20
Any well-behaving drive is supported. I have used EXB8505 some years ag=
o=20
and I don't think this problem has anything to do with the drive.

--=20
Kai
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
