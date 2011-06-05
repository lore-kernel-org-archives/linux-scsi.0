From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25192] PCI doesn't work on BCM91250A MIPS board
Date: Sun, 5 Jun 2011 05:19:55 GMT
Message-ID: <201106050519.p555Jt0Q007739@demeter1.kernel.org>
References: <bug-25192-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:52252 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab1FEFT4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Jun 2011 01:19:56 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p555Jtq8007740
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 5 Jun 2011 05:19:55 GMT
In-Reply-To: <bug-25192-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=25192





--- Comment #15 from Matt Turner <mattst88@gmail.com>  2011-06-05 05:19:48 ---
Created an attachment (id=60822)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=60822)
9500S debugging - 1GB RAM

Adam,

This board has a strange memory layout, which screws with PCI cards if you have
more than 1GB of RAM, so the attached file is the debugging statement you
requested with only 1GB of RAM installed (I had 2GB installed before). (In
big-endian mode this time)

As you can see, there's no catastrophic null pointer dereference. Perhaps this
is useful? Let me know, thanks.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
