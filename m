From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13547] Buffer overrun in FlashPoint.c
Date: Thu, 18 Jun 2009 07:47:49 GMT
Message-ID: <200906180747.n5I7lnKh025828@demeter.kernel.org>
References: <bug-13547-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:60373 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758884AbZFRHrr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Jun 2009 03:47:47 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n5I7lnqn025829
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2009 07:47:49 GMT
In-Reply-To: <bug-13547-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13547





--- Comment #2 from Martin Ettl <ettl.martin@gmx.de>  2009-06-18 07:47:48 ---
Yes i see. You can avoid the if-statement by using this:

for (thisCard = 0; thisCard < MAX_CARDS; thisCard++) 

Regards

Martin

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
