From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25192] PCI doesn't work on BCM91250A MIPS board
Date: Sun, 5 Jun 2011 05:24:51 GMT
Message-ID: <201106050524.p555Opsp010986@demeter2.kernel.org>
References: <bug-25192-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:45652 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab1FEFYv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Jun 2011 01:24:51 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p555Opfv010987
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 5 Jun 2011 05:24:51 GMT
In-Reply-To: <bug-25192-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=25192





--- Comment #16 from Matt Turner <mattst88@gmail.com>  2011-06-05 05:24:44 ---
I should have added that with 1GB of RAM, a 32-bit sata_sil card, 32-bit
aic7xxx scsi card, and a 64-bit tg3 ethernet card work. With 2GB RAM, only the
64-bit tg3 ethernet card works.

The 3Ware 9500S is the only card I've tried that's failed with 1GB of RAM.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
