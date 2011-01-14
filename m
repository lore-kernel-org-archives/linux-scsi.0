From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 26692] Fusion MPT SPI bringup takes 80 seconds when the kernel
 is quiet
Date: Fri, 14 Jan 2011 15:47:02 GMT
Message-ID: <201101141547.p0EFl22L016181@demeter2.kernel.org>
References: <bug-26692-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:35352 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab1ANPrE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jan 2011 10:47:04 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p0EFl2oY016184
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 14 Jan 2011 15:47:02 GMT
In-Reply-To: <bug-26692-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D26692





--- Comment #1 from Ferenc W=C3=A1gner <wferi@niif.hu>  2011-01-14 15:4=
6:58 ---
Oh no, I mixed it up...

Actually, the 'quiet' parameter causes the problems (the oops under 2.6=
=2E32 and
the delay under 2.6.37), and the thing works perfectly when 'quiet' is =
not
present on the kernel command line. To be precise, even after booting w=
ith
'quiet', issuing a 'dmesg -n8' before 'modprobe mptspi' avoids the oops=
 under
2.6.32.

--=20
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3Demai=
l
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
