From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12207] block reads/writes > 122880 bytes to USB tape drive
 gives EBUSY
Date: Fri, 10 Apr 2009 19:29:18 GMT
Message-ID: <200904101929.n3AJTIkC020026@demeter.kernel.org>
References: <bug-12207-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:48606 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757175AbZDJT3T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Apr 2009 15:29:19 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n3AJTIE7020027
	for <linux-scsi@vger.kernel.org>; Fri, 10 Apr 2009 19:29:18 GMT
In-Reply-To: <bug-12207-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=3D12207





--- Comment #29 from Kai M=C3=A4kisara <kai.makisara@kolumbus.fi>  2009=
-04-10 19:29:18 ---
On Fri, 10 Apr 2009, bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=3D12207
>=20
>=20
>=20
>=20
>=20
> --- Comment #28 from Alan Stern <stern@rowland.harvard.edu>  2009-04-=
10 15:19:23 ---
> On Fri, 10 Apr 2009 bugzilla-daemon@bugzilla.kernel.org wrote:
>=20
> > --- Comment #27 from oshida@bb-next.net  2009-04-10 09:48:44 ---
=2E..
> > > Did you know that max_sectors can also be changed through the blo=
ck=20
> > > interface?
> >=20
> > I'm sorry I did not. Thanks for teaching.
> > But I could not find the device (of course tape drive) under that t=
ree. I think
> > that is just for kinds of block device which can be manipulated wit=
h T10/SBC
> > command set.
>=20
> No, it is for all block devices.  If you can't find your device under=
=20
> /sys/block/ then look for it somewhere else, such as under=20
> /sys/bus/scsi/devices/.
>=20
Maybe you should check your facts before telling others where to look.=20
max_sectors_kb etc. exist only for block devices (in the Unix sense).=20
Tapes are character devices.

Kai

--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are the assignee for the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
