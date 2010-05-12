From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14831] mptsas - Use of ATA command pass-through results in
 unreliable operation - drive / controller resets
Date: Wed, 12 May 2010 09:04:03 GMT
Message-ID: <201005120904.o4C943VG009486@demeter.kernel.org>
References: <bug-14831-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58613 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929Ab0ELJEE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2010 05:04:04 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4C944aH009487
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 12 May 2010 09:04:04 GMT
In-Reply-To: <bug-14831-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=14831





--- Comment #22 from Tim Small <tim@seoss.co.uk>  2010-05-12 09:03:57 ---
(In reply to comment #21)

> So apparently this bug affects mpt2sas too???

Hi Brian,

Can you give the drive makes and models too?  Some recent WD drives can lock-up
on SMART with all controllers.

Thanks,

Tim.

p.s. please try and keep the quotes under control in comments - only quote the
relevant parts!

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
