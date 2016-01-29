From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 111441] iscsi fails to attach to targets
Date: Fri, 29 Jan 2016 19:11:10 +0000
Message-ID: <bug-111441-11613-HfRkJmBZEP@https.bugzilla.kernel.org/>
References: <bug-111441-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56805 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420AbcA2TLO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jan 2016 14:11:14 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E9E2B2035D
	for <linux-scsi@vger.kernel.org>; Fri, 29 Jan 2016 19:11:12 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 6779C2038D
	for <linux-scsi@vger.kernel.org>; Fri, 29 Jan 2016 19:11:11 +0000 (UTC)
In-Reply-To: <bug-111441-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D111441

--- Comment #6 from Serguei Bezverkhi <sbezverk@cisco.com> ---
If you send me the diff for your patch, I will build new kernel myself.

Serguei


Serguei Bezverkhi,
TECHNICAL LEADER.SERVICES
Global SP Services
sbezverk@cisco.com
Phone:=C2=A0+1 416 306 7312
Mobile:=C2=A0+1 514 234 7374

CCIE (R&S,SP,Sec) - #9527

Cisco.com



=C2=A0Think before you print.
This email may contain confidential and privileged material for the sol=
e use of
the intended recipient. Any review, use, distribution or disclosure by =
others
is strictly prohibited. If you are not the intended recipient (or autho=
rized to
receive for the recipient), please contact the sender by reply email an=
d delete
all copies of this message.
Please=C2=A0click here=C2=A0for Company Registration Information.




-----Original Message-----
=46rom: Michael Christie [mailto:michaelc@cs.wisc.edu]=20
Sent: Friday, January 29, 2016 2:09 PM
To: Serguei Bezverkhi (sbezverk) <sbezverk@cisco.com>
Cc: bugzilla-daemon@bugzilla.kernel.org; linux-scsi@vger.kernel.org
Subject: Re: [Bug 111441] New: iscsi fails to attach to targets


> On Jan 29, 2016, at 6:04 AM, Serguei Bezverkhi (sbezverk) <sbezverk@c=
isco.com> wrote:
>=20
> Actually this server uses both cases: Local taregts (since it is Open=
Stack server) and remote targets as it tries to mount 4 remotefile syst=
ems. =20
>=20
> You are correct, I always use the same box I just change the kernel i=
t is using to boot. No other changes to the environment. I do not mind =
to load a test kernel without that suspected patch, just get me the RPM=
=2E
>=20

I do not know what you mean. I think the patch I sent will fix the sysf=
s errors
caused due to alua not being setup properly on your system and scsi_dh_=
alua
failing to attach. That patch should be applied to the 4.4 upstream ker=
nel. Are
you saying you want me to make you a kernel rpm?

--=20
You are receiving this mail because:
You are the assignee for the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
