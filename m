From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13519] Syntax error. Not enough parameters for macro
 'qla_printk'.
Date: Fri, 12 Jun 2009 12:35:51 GMT
Message-ID: <200906121235.n5CCZpBr031478@demeter.kernel.org>
References: <bug-13519-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:33196 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbZFLMft (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jun 2009 08:35:49 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n5CCZpXB031479
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2009 12:35:51 GMT
In-Reply-To: <bug-13519-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13519





--- Comment #2 from Martin Ettl <ettl.martin@gmx.de>  2009-06-12 12:35:51 ---
You are right, this is a false positive of cppcheck

Thanks anyway

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
