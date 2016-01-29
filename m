From: "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
Subject: RE: [Bug 111441] New: iscsi fails to attach to targets
Date: Fri, 29 Jan 2016 19:11:07 +0000
Message-ID: <4c4653b259cd4f1887505dfc61d500a8@XCH-ALN-006.cisco.com>
References: <bug-111441-11613@https.bugzilla.kernel.org/>
 <56AAC605.1080707@cs.wisc.edu>
 <9cf7d536fcc44d9d8f35d81503543497@XCH-ALN-006.cisco.com>
 <36266784-E570-406E-8C3A-56D0F728768B@cs.wisc.edu>
 <a331d83963b64d7da77352b01c1d10da@XCH-ALN-006.cisco.com>
 <01C3BBA0-3D1A-461A-9EEF-512A57707325@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcdn-iport-3.cisco.com ([173.37.86.74]:42468 "EHLO
	rcdn-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbcA2TLI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jan 2016 14:11:08 -0500
In-Reply-To: <01C3BBA0-3D1A-461A-9EEF-512A57707325@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Christie <michaelc@cs.wisc.edu>
Cc: "bugzilla-daemon@bugzilla.kernel.org" <bugzilla-daemon@bugzilla.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

If you send me the diff for your patch, I will build new kernel myself.

Serguei


Serguei Bezverkhi,
TECHNICAL LEADER.SERVICES
Global SP Services
sbezverk@cisco.com
Phone:=A0+1 416 306 7312
Mobile:=A0+1 514 234 7374

CCIE (R&S,SP,Sec) - #9527

Cisco.com



=A0Think before you print.
This email may contain confidential and privileged material for the sol=
e use of the intended recipient. Any review, use, distribution or discl=
osure by others is strictly prohibited. If you are not the intended rec=
ipient (or authorized to receive for the recipient), please contact the=
 sender by reply email and delete all copies of this message.
Please=A0click here=A0for Company Registration Information.




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
s errors caused due to alua not being setup properly on your system and=
 scsi_dh_alua failing to attach. That patch should be applied to the 4.=
4 upstream kernel. Are you saying you want me to make you a kernel rpm?
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
