From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14577] Data Corruption with Adaptec 52445
Date: Tue, 10 Nov 2009 13:39:30 GMT
Message-ID: <200911101339.nAADdUx8015970@demeter.kernel.org>
References: <bug-14577-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:32974 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbZKJNjY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2009 08:39:24 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAADdUGT015972
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2009 13:39:30 GMT
In-Reply-To: <bug-14577-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14577





--- Comment #3 from lkolbe@techfak.uni-bielefeld.de  2009-11-10 13:39:29 ---
Created an attachment (id=23728)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=23728)
contents of /proc/modules on the working system (2.6.30)

/proc/version is: Linux version 2.6.30-1-amd64 (Debian 2.6.30-5+techfaklenny1)
(sfrey@TechFak.Uni-Bielefeld.DE) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #1 SMP
Sat Aug 15 11:20:08 UTC 2009

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
