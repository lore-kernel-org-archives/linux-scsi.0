From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15185] Sending a 48bit ATA-Command with "CheckCondition"
 through SG_IO does not return correct 48bit sense descriptor
Date: Mon, 1 Feb 2010 21:22:04 GMT
Message-ID: <201002012122.o11LM4ca007859@demeter.kernel.org>
References: <bug-15185-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:33197 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884Ab0BAVWH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Feb 2010 16:22:07 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o11LM4U7007861
	for <linux-scsi@vger.kernel.org>; Mon, 1 Feb 2010 21:22:04 GMT
In-Reply-To: <bug-15185-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=3D15185


Stefan H=C3=BCbner <stefan.huebner@stud.tu-ilmenau.de> changed:

           What    |Removed                     |Added
-----------------------------------------------------------------------=
-----
     Kernel Version|2.6.31                      |2.6.32




--- Comment #3 from Stefan H=C3=BCbner <stefan.huebner@stud.tu-ilmenau.=
de>  2010-02-01 21:22:04 ---
Just to clear up: sorry, I forgot I recently updated to 2.6.32.  Change=
d
bug-description accordingly.

--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
