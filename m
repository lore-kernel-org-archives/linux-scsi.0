From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14577] Data Corruption with Adaptec 52445, Firmware 5.2-0
 (17380)
Date: Tue, 10 Nov 2009 14:51:43 GMT
Message-ID: <200911101451.nAAEphks029478@demeter.kernel.org>
References: <bug-14577-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58741 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbZKJOvi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2009 09:51:38 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAAEphM7029479
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2009 14:51:43 GMT
In-Reply-To: <bug-14577-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14577





--- Comment #6 from lkolbe@techfak.uni-bielefeld.de  2009-11-10 14:51:42 ---
I understand that indicates a hardware failure, but this doesn't occur when
using 2.6.30. That's why I opened it as a regression in the first place. I
welcome input from the aacraid people, of course :)

-- 
Lukas

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
