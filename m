From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 26692] Fusion MPT SPI bringup takes 80 seconds when the kernel
 is quiet
Date: Thu, 25 Aug 2011 18:00:35 GMT
Message-ID: <201108251800.p7PI0Z9I011403@demeter2.kernel.org>
References: <bug-26692-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:56072 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab1HYSAf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Aug 2011 14:00:35 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.4) with ESMTP id p7PI0ZAL011404
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2011 18:00:35 GMT
In-Reply-To: <bug-26692-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D26692





--- Comment #6 from Ferenc W=C3=A1gner <wferi@niif.hu>  2011-08-25 18:0=
0:33 ---
Created an attachment (id=3D70232)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=3D70232)
dmesg of a quick boot ('debug' passed to the kernel) with
mpt_debug_level=3D0xbbbff9

I post a "normal" dmesg for comparison. The boot is also quick if I sim=
ply
leave off the 'quiet' parameter, 'debug' isn't required at all.

--=20
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3Demai=
l
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
