From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15341] Load goes up very high when we traverse the large tree
Date: Fri, 19 Feb 2010 17:35:13 GMT
Message-ID: <201002191735.o1JHZDHJ016409@demeter.kernel.org>
References: <bug-15341-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:54610 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139Ab0BSRfO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Feb 2010 12:35:14 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1JHZE1c016413
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 19 Feb 2010 17:35:14 GMT
In-Reply-To: <bug-15341-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15341





--- Comment #7 from Frederic MASSOT <frederic@juliana-multimedia.com>  2010-02-19 17:35:06 ---
Created an attachment (id=25119)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=25119)
dmesg after "echo w > /proc/sysrq-trigger"

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
