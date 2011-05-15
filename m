From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 33802] list_del corruption in sd driver since 2.6.39-rc4
Date: Sun, 15 May 2011 11:00:20 GMT
Message-ID: <201105151100.p4FB0KV3015697@demeter2.kernel.org>
References: <bug-33802-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:40920 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859Ab1EOLAV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 15 May 2011 07:00:21 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p4FB0KBC015699
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 15 May 2011 11:00:20 GMT
In-Reply-To: <bug-33802-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=33802


Christian Casteyde <casteyde.christian@free.fr> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |CLOSED




--- Comment #5 from Christian Casteyde <casteyde.christian@free.fr>  2011-05-15 11:00:17 ---
I didn't reproduced on recent kernels.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
