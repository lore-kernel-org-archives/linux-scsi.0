From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14577] Data Corruption with Adaptec 52445, Firmware 5.2-0
 (17380)
Date: Tue, 17 Nov 2009 12:25:25 GMT
Message-ID: <200911171225.nAHCPPBe028647@demeter.kernel.org>
References: <bug-14577-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:32788 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbZKQMZT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Nov 2009 07:25:19 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAHCPPgH028648
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2009 12:25:25 GMT
In-Reply-To: <bug-14577-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14577





--- Comment #8 from lkolbe@techfak.uni-bielefeld.de  2009-11-17 12:25:21 ---
bugzilla-daemon@bugzilla.kernel.org wrote:

>Hi James,
>
>We'll look into this issue and get back to you. I wonder if they are genuine
>write errors due to the medium errors. Is this problem seen with other RAID
>volumes or just with this one particular volume? 
>
>Are you running Adaptec Storage Manager Software on this system? If so, can you
>please collect the support.zip file? Support.zip can be collected by clicking
>"support.zip" under the "actions" menu. The Support.zip file provides us
>additional information on any disk errors that might have happened in the
>system.

Hello Gana,

we have the arcconf utility available on that system, but since it is
Debian Lenny based and we only found RPMs for the storage manager, we
cannot run it on that system (I suppose). Would the arcconf utility be
of any help here? 

>Thanks,
>Gana 

Thanks for your help,
Lukas Kolbe

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
