From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60758] module scsi_wait_scan not found kernel panic on boot
Date: Wed, 23 Oct 2013 13:48:08 +0000
Message-ID: <bug-60758-11613-RXheljXCxA@https.bugzilla.kernel.org/>
References: <bug-60758-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:33441 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008Ab3JWNsQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2013 09:48:16 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 60F9A203FB
	for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2013 13:48:15 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id C8DF32041B
	for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2013 13:48:08 +0000 (UTC)
In-Reply-To: <bug-60758-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D60758

--- Comment #42 from newbie <kernel.tw@gmail.com> ---
(In reply to zakrzewskim from comment #41)
> Please test (In reply to newbie from comment #40)
> > =E3=80=80I check my boot.log on CentOS 6.4 x86_64 with 3.10.17 toda=
y,
> > seem
> >=20
> >     FATAL: Module scsi_wait_scan not found
> >=20
> > still appear, but can boot in to the system at least.
>=20
> Please test kernel 3.11.6 too.

I'd solve other problem with my 3.10.17 config now ...

--=20
You are receiving this mail because:
You are the assignee for the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
