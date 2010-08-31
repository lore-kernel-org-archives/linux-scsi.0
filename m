From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 17551] mpt2sas -- spurious hotplug event causes drive drop to
 drop out of JBOD array
Date: Tue, 31 Aug 2010 08:08:09 GMT
Message-ID: <201008310808.o7V8896k003524@demeter1.kernel.org>
References: <bug-17551-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:53579 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756832Ab0HaIIJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Aug 2010 04:08:09 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o7V889in003525
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 31 Aug 2010 08:08:09 GMT
In-Reply-To: <bug-17551-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=17551





--- Comment #1 from starlight@binnacle.cx  2010-08-31 08:08:04 ---
Created an attachment (id=28611)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=28611)
kernel messages from failure with logging_level=0x1F8

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
