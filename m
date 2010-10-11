From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 20072] tapeinfo reports MaxBlock: 16777215  but writes with
 blocksize >2M fail
Date: Mon, 11 Oct 2010 10:20:06 GMT
Message-ID: <201010111020.o9BAK6uK008866@demeter2.kernel.org>
References: <bug-20072-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:45332 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab0JKKUH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Oct 2010 06:20:07 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o9BAK6Im008867
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 11 Oct 2010 10:20:07 GMT
In-Reply-To: <bug-20072-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=20072





--- Comment #1 from lkolbe@techfak.uni-bielefeld.de  2010-10-11 10:20:06 ---
Created an attachment (id=33232)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=33232)
lspci -vvvn of system

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
