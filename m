From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60758] module scsi_wait_scan not found kernel panic on boot
Date: Wed, 23 Oct 2013 11:21:29 +0000
Message-ID: <bug-60758-11613-OB9gmo2zZm@https.bugzilla.kernel.org/>
References: <bug-60758-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:55662 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988Ab3JWLVe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2013 07:21:34 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 18E6C203A3
	for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2013 11:21:33 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 36B8320343
	for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2013 11:21:30 +0000 (UTC)
In-Reply-To: <bug-60758-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D60758

--- Comment #40 from newbie <kernel.tw@gmail.com> ---
=E3=80=80I check my boot.log on CentOS 6.4 x86_64 with 3.10.17 today,
seem

    FATAL: Module scsi_wait_scan not found

still appear, but can boot in to the system at least.

--=20
You are receiving this mail because:
You are the assignee for the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
