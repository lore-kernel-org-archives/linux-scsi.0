From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 17551] mpt2sas -- spurious hotplug event causes drive to drop
 out of JBOD array
Date: Sat, 4 Sep 2010 20:14:45 GMT
Message-ID: <201009042014.o84KEjdd014623@demeter1.kernel.org>
References: <bug-17551-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:35985 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab0IDUOr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Sep 2010 16:14:47 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o84KEkdM014624
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sat, 4 Sep 2010 20:14:46 GMT
In-Reply-To: <bug-17551-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=17551





--- Comment #8 from starlight@binnacle.cx  2010-09-04 20:14:36 ---
Created an attachment (id=28962)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=28962)
kernel log from yet another failure

yet another controller failure

different profile:  infinite hot-plug event loop this time

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
