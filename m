From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16547] mptscsih: ioc0: attempting task abort, raid array LUNs
 not detected properly on some boots
Date: Mon, 9 Aug 2010 09:35:15 GMT
Message-ID: <201008090935.o799ZFRC023355@demeter.kernel.org>
References: <bug-16547-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:44630 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904Ab0HIJfQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2010 05:35:16 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o799ZFSF023364
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 9 Aug 2010 09:35:15 GMT
In-Reply-To: <bug-16547-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16547





--- Comment #2 from Martin Steigerwald <ms@teamix.de>  2010-08-09 09:35:12 ---
Created an attachment (id=27387)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=27387)
config for the 2.6.32-5-amd64 debian backport kernel

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are on the CC list for the bug.
You are watching the assignee of the bug.
