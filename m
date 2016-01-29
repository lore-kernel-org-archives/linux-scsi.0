From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 111441] iscsi fails to attach to targets
Date: Fri, 29 Jan 2016 03:05:05 +0000
Message-ID: <bug-111441-11613-exNmQHyY9a@https.bugzilla.kernel.org/>
References: <bug-111441-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:59051 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbcA2DFI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2016 22:05:08 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 57BAD20138
	for <linux-scsi@vger.kernel.org>; Fri, 29 Jan 2016 03:05:07 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id A65F520265
	for <linux-scsi@vger.kernel.org>; Fri, 29 Jan 2016 03:05:05 +0000 (UTC)
In-Reply-To: <bug-111441-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D111441

--- Comment #2 from Serguei Bezverkhi <sbezverk@cisco.com> ---
HI Mike,

Thank you for looking into this issue.
I reproduced this issue  this using both mainline compiled kernel and t=
he one
posted by El Repo.  I used both of these kernels with RHEL 7.2, both ke=
rnels
showed exactly the same issue. When I rollback to the original kernel
3.10.0-327.4.4, I do not see the issue.

As per your request attaching kernel config file. Please let me know if=
 you
need any additional info or if you want to take a look at the router, I=
 can
setup a webex meeting to show you the issue.

Thank you

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
=46rom: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Mike Christie
Sent: Thursday, January 28, 2016 8:53 PM
To: bugzilla-daemon@bugzilla.kernel.org; linux-scsi@vger.kernel.org
Subject: Re: [Bug 111441] New: iscsi fails to attach to targets

On 01/28/2016 04:51 PM, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D111441
>=20
>             Bug ID: 111441
>            Summary: iscsi fails to attach to targets
>            Product: IO/Storage
>            Version: 2.5
>     Kernel Version: 4.4.0-1
>           Hardware: x86-64
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW


> 4.4.0-1.el7.elrepo.x86_64 #1

I have not seen this oops before. We saw similar ones around 5 or 6 yea=
rs ago,
but they were due to some sysfs or block or scsi issue (I cannot rememb=
er
exacty) and fixed there.

Is this a distro kernel or mainline. BZ says mainline, but the kernel n=
ame in
bug looks like a red hat related one. Where did you get it?

I do not hit this in 4.4 mainline. Send me your kernel .config, so I ca=
n make
sure I have the same options.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n the
body of a message to majordomo@vger.kernel.org More majordomo info at=20
http://vger.kernel.org/majordomo-info.html

--=20
You are receiving this mail because:
You are the assignee for the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
