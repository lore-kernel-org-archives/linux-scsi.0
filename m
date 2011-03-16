From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 31192] ioctl SG_GET_REQUEST_TABLE returns 64-bit structure to
 32-bit app.
Date: Wed, 16 Mar 2011 13:53:39 GMT
Message-ID: <201103161353.p2GDrdiN021331@demeter2.kernel.org>
References: <bug-31192-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:55740 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab1CPNxk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Mar 2011 09:53:40 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p2GDrdEr021332
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 16 Mar 2011 13:53:39 GMT
In-Reply-To: <bug-31192-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=31192


Jeff Byers <jbyers@stonefly.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
           Platform|All                         |x86-64




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
