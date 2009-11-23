From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14563] SCSI tape driver: Spurious EIO and kernel BUG
Date: Mon, 23 Nov 2009 20:12:40 GMT
Message-ID: <200911232012.nANKCeQN001054@demeter.kernel.org>
References: <bug-14563-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:45636 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756736AbZKWUMd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Nov 2009 15:12:33 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nANKCeNV001055
	for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2009 20:12:40 GMT
In-Reply-To: <bug-14563-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=3D14563





--- Comment #19 from Kai M=C3=A4kisara <kai.makisara@kolumbus.fi>  2009=
-11-23 20:12:38 ---
On Mon, 23 Nov 2009, bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=3D14563
>=20
>=20
>=20
>=20
>=20
> --- Comment #18 from Joachim Breuer <linux-kernel@jmbreuer.net>  2009=
-11-23 12:10:04 ---
> Created an attachment (id=3D23877)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=3D23877)
>  --> (http://bugzilla.kernel.org/attachment.cgi?id=3D23877)
> Console output, 2.6.30.3, fixed tape block size 512k, patch by FUJITA=
 Tomonori
> 2009-11-19
>=20
> The patch you sent changes the behavior: I still get the EIO after (i=
n this
> case) 239 I/O requests while writing to the tape; but the machine no =
longer
> hard-crashes with a BUG.
>=20
> [I've removed the try_rdio=3D0/try_wdio=3D0 module parameters for thi=
s test.]
>=20
> Attached is the console log as usual with my comments interspersed; i=
f I read
> this correctly "st0: Number of r/w requests 239, dio used in 1, pages=
 128."
> direct I/O is used at least once before the problem occurs.
>=20
Are you sure that you have used the patched st? The log does not show t=
he=20
the debugging output from Fujita's patch. It also shows the problem=20
occurring before the patch:

st0: Block size: 524288, buffer size: 516096 (0 blocks).

Kai

--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are the assignee for the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
