From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 11646] QLA2xxx: Kernel deadlock on high load somewhere after
 2.6.20
Date: Wed, 3 Mar 2010 09:59:58 GMT
Message-ID: <201003030959.o239xwHA010826@demeter.kernel.org>
References: <bug-11646-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:59117 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab0CCJ77 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2010 04:59:59 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o239xwiL010827
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 3 Mar 2010 09:59:58 GMT
In-Reply-To: <bug-11646-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11646





--- Comment #33 from Csillag Tamas <cstamas@digitus.itk.ppke.hu>  2010-03-03 09:59:55 ---
Dear Bernd Zeimetz,

Can you tell us what version your qlogic bios is?

If its not recent you can try to upgrade:
http://www-947.ibm.com/systems/support/supportsite.wss/selectproduct?familyind=5305593&typeind=0&osind=0&continue.x=18&continue.y=13&brandind=5000008&oldbrand=5000008&oldfamily=5305593&oldtype=0&taskind=2&matrix=Y&psid=bm#UpdateXpress%20System%20Pack

It seems that this the problem for me.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
