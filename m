From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 26692] Fusion MPT SPI bringup takes 80 seconds when the kernel
 is quiet
Date: Fri, 26 Aug 2011 09:15:22 GMT
Message-ID: <201108260915.p7Q9FMXw024419@demeter2.kernel.org>
References: <bug-26692-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:47200 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab1HZJPX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Aug 2011 05:15:23 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.4) with ESMTP id p7Q9FM2q024420
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2011 09:15:22 GMT
In-Reply-To: <bug-26692-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D26692


=46erenc W=C3=A1gner <wferi@niif.hu> changed:

           What    |Removed                     |Added
-----------------------------------------------------------------------=
-----
     Kernel Version|2.6.37                      |3.1.0-rc3




--=20
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3Demai=
l
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
