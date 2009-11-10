From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14577] Data Corruption with Adaptec 52445
Date: Tue, 10 Nov 2009 13:35:54 GMT
Message-ID: <200911101335.nAADZs65015309@demeter.kernel.org>
References: <bug-14577-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38858 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbZKJNfs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2009 08:35:48 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAADZs0G015310
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2009 13:35:54 GMT
In-Reply-To: <bug-14577-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14577





--- Comment #2 from lkolbe@techfak.uni-bielefeld.de  2009-11-10 13:35:53 ---
Created an attachment (id=23727)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=23727)
lsscsi -t/-v/-c/-H output on a working kernel

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
