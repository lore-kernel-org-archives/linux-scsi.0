From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60758] module scsi_wait_scan not found kernel panic on boot
Date: Sat, 19 Oct 2013 15:38:59 +0000
Message-ID: <bug-60758-11613-kIvAoCFJ2j@https.bugzilla.kernel.org/>
References: <bug-60758-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:33681 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258Ab3JSPjD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Oct 2013 11:39:03 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E7C782053A
	for <linux-scsi@vger.kernel.org>; Sat, 19 Oct 2013 15:39:01 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 84CCC2051F
	for <linux-scsi@vger.kernel.org>; Sat, 19 Oct 2013 15:39:00 +0000 (UTC)
In-Reply-To: <bug-60758-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D60758

newbie <kernel.tw@gmail.com> changed:

           What    |Removed                     |Added
-----------------------------------------------------------------------=
-----
                 CC|                            |kernel.tw@gmail.com

--- Comment #38 from newbie <kernel.tw@gmail.com> ---
Hi:

=E3=80=80I had the same problem with 3.10.16 on CentOS 6.4 x86_64 too..=
=2E
I don't know it's my wrong when I make config, or other people too?

--=20
You are receiving this mail because:
You are the assignee for the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
