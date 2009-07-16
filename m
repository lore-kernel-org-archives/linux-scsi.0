From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13783] udev causes high cpu usage
Date: Thu, 16 Jul 2009 07:36:57 GMT
Message-ID: <200907160736.n6G7avx5008588@demeter.kernel.org>
References: <bug-13783-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:55414 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbZGPHg5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jul 2009 03:36:57 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n6G7avtK008589
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2009 07:36:57 GMT
In-Reply-To: <bug-13783-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13783





--- Comment #1 from Andreas Fackler <AndreasFackler@web.de>  2009-07-16 07:36:56 ---
Created an attachment (id=22373)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=22373)
Output of "udevadm monitor --environment" with udev-141-1 and kernel 2.6.30

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
