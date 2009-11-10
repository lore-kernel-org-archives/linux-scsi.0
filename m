From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14577] Data Corruption with Adaptec 52445
Date: Tue, 10 Nov 2009 13:35:00 GMT
Message-ID: <200911101335.nAADZ0eX015171@demeter.kernel.org>
References: <bug-14577-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38852 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbZKJNez (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2009 08:34:55 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAADZ0Hn015172
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2009 13:35:00 GMT
In-Reply-To: <bug-14577-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14577





--- Comment #1 from lkolbe@techfak.uni-bielefeld.de  2009-11-10 13:35:00 ---
Created an attachment (id=23726)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=23726)
lspci -vvv on a working kernel

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
