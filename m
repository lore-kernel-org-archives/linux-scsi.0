From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60758] module scsi_wait_scan not found kernel panic on boot
Date: Wed, 06 Nov 2013 15:52:39 +0000
Message-ID: <bug-60758-11613-KssBfHkMOk@https.bugzilla.kernel.org/>
References: <bug-60758-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:53583 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754849Ab3KFPwn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Nov 2013 10:52:43 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 791DD205F5
	for <linux-scsi@vger.kernel.org>; Wed,  6 Nov 2013 15:52:42 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 3E45E205B3
	for <linux-scsi@vger.kernel.org>; Wed,  6 Nov 2013 15:52:40 +0000 (UTC)
In-Reply-To: <bug-60758-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D60758

--- Comment #44 from Alan Bartlett <ajb@elrepo.org> ---
(In reply to newbie from comment #43)
> 3.10.18 still show one line
>=20
> =E3=80=80FATAL: Module scsi_wait_scan not found
>=20
> but boot ok.

That is not a message output by the kernel but is the result of line nu=
mber 165
in the "userland" file, /etc/rc.d/rc.sysinit, of RHEL 6 (and its clones=
).

If you do not like seeing the message, just "comment out" line number 1=
65 in
your /etc/rc.d/rc.sysinit file.

--=20
You are receiving this mail because:
You are the assignee for the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
