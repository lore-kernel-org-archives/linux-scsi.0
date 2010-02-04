From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15227] sys-kernel/gentoo-sources-2.6.30-r4 - amlabel triggers
 opcode 0000 kernel bug
Date: Thu, 4 Feb 2010 21:17:37 GMT
Message-ID: <201002042117.o14LHbI9016020@demeter.kernel.org>
References: <bug-15227-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34045 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757865Ab0BDVRh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2010 16:17:37 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o14LHbcB016024
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 4 Feb 2010 21:17:37 GMT
In-Reply-To: <bug-15227-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=3D15227





--- Comment #2 from Kai M=C3=A4kisara <kai.makisara@kolumbus.fi>  2010-=
02-04 21:17:35 ---
On Thu, 4 Feb 2010, bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=3D15227
>=20
>=20
> Andrew Morton <akpm@linux-foundation.org> changed:
>=20
>            What    |Removed                     |Added
> ---------------------------------------------------------------------=
-------
>                  CC|                            |akpm@linux-foundatio=
n.org,
>                    |                            |kai.makisara@kolumbu=
s.fi
>           Component|Other                       |Other
>          AssignedTo|other_other@kernel-bugs.osd |scsi_drivers-other@k=
ernel-b
>                    |l.org                       |ugs.osdl.org
>             Product|Other                       |SCSI Drivers
>=20
>=20
>=20
>=20
> --- Comment #1 from Andrew Morton <akpm@linux-foundation.org>  2010-0=
2-04 20:34:12 ---
> Looks like an st bug.  Reassigned to scsi, cc'ed Kai.
>=20
Do the affected kernels include the fix in=20
http://marc.info/?l=3Dlinux-scsi&m=3D125919508329412 ? This is in 2.6.3=
3 and=20
in 2.6.32.something.

Kai

--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
