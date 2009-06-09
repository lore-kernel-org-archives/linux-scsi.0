From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13311] mptsas: ioc0: removing ssp device, kernel oops
Date: Tue, 9 Jun 2009 21:30:46 GMT
Message-ID: <200906092130.n59LUkrT015788@demeter.kernel.org>
References: <bug-13311-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:39083 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbZFIVao (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2009 17:30:44 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n59LUkQO015789
	for <linux-scsi@vger.kernel.org>; Tue, 9 Jun 2009 21:30:46 GMT
In-Reply-To: <bug-13311-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13311





--- Comment #4 from Mike Loseke <mike.tummy@gmail.com>  2009-06-09 21:30:46 ---
Created an attachment (id=21835)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=21835)
log entries for the 2.6.29 oops, re message #3

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
