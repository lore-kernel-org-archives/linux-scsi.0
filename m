From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14534] mvsas : repeatably disconnects all disks during RAID6
 resync
Date: Tue, 3 Nov 2009 02:10:24 GMT
Message-ID: <200911030210.nA32AOhQ015318@demeter.kernel.org>
References: <bug-14534-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:45859 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990AbZKCCKT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2009 21:10:19 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nA32AOwp015319
	for <linux-scsi@vger.kernel.org>; Tue, 3 Nov 2009 02:10:24 GMT
In-Reply-To: <bug-14534-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14534





--- Comment #1 from Arno Wagner <wagner@tik.ee.ethz.ch>  2009-11-03 02:10:23 ---
Created an attachment (id=23625)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=23625)
kernel .config

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
