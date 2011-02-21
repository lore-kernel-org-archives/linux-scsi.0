From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 29442] target: Race between target driver unregistration and
 LUN removal
Date: Mon, 21 Feb 2011 18:43:34 GMT
Message-ID: <201102211843.p1LIhYKq016740@demeter1.kernel.org>
References: <bug-29442-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:53352 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab1BUSne (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Feb 2011 13:43:34 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p1LIhYdP016744
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2011 18:43:34 GMT
In-Reply-To: <bug-29442-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=29442





--- Comment #2 from Bart Van Assche <bart.vanassche@gmail.com>  2011-02-21 18:43:32 ---
Created an attachment (id=48622)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=48622)
bash script to start and stop target core + ib_srpt

I have attached the script that has been used during the test to start and stop
the target core and ib_srpt. That will probably make more clear what was going
on. The kernel bug was triggered by reading data on the initiator
simultaneously with running "start-lio stop" on the target.

Note: before you can run this script the initiator IDs in the variable
"initiators" will have to be replaced by those of your InfiniBand setup.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
