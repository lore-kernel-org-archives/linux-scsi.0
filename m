From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10374] sym53c8xx: weird behavior with udev
Date: Wed,  2 Apr 2008 03:29:52 -0700 (PDT)
Message-ID: <20080402102952.8332711D108@picon.linux-foundation.org>
References: <bug-10374-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46550 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752126AbYDBKaV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Apr 2008 06:30:21 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m32ATqrF000503
	for <linux-scsi@vger.kernel.org>; Wed, 2 Apr 2008 03:29:53 -0700
In-Reply-To: <bug-10374-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10374





------- Comment #10 from seraph@xs4all.nl  2008-04-02 03:29 -------
Maybe it's nothing, but I did notice that sym53c8xx compiles with a warning of
a possibly uninitialized variable:

  CC [M]  drivers/scsi/sym53c8xx_2/sym_glue.o
drivers/scsi/sym53c8xx_2/sym_glue.c: In function 'sym_eh_handler':
drivers/scsi/sym53c8xx_2/sym_glue.c:612: warning: 'io_reset' may be used
uninitialized in this function


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
