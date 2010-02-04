From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15001] megaraid_sas fills dmesg with megasas: Failed to copy
 out to user sense data
Date: Thu, 4 Feb 2010 15:36:18 GMT
Message-ID: <201002041536.o14FaIuF031919@demeter.kernel.org>
References: <bug-15001-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:59175 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758139Ab0BDPgT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2010 10:36:19 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o14FaJ1E031923
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 4 Feb 2010 15:36:19 GMT
In-Reply-To: <bug-15001-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15001





--- Comment #9 from Tomas Henzl <thenzl@redhat.com>  2010-02-04 15:36:13 ---
(In reply to comment #8)
> (In reply to comment #7)
> > (In reply to comment #6)
> > > thank you for the patch , it handles the issue , tested on 2.6.32.7 .
> > 
> > That means that you no more see the 
> > "megasas: Failed to copy out to user sense data" 
> Yes , that means that I don't see this message any more , 
> and what does it mean "Failed to copy out to user sense data" ?
That means that the function copy_to_user in the driver failed and the ioctl
returned EFAULT. Usually programs can cope with that, but it could mean that
they are not able to collect informations from that device.

> > or have you also verified that the management software works as expected?
> And I still can retrieve information with MegaCli utility , should I check
> something special ?
I'm not sure with MegaCli, what I meant here is the Dell management sw 'Open
Manage', so if you can check if this sw can collect info from  megaraid driver.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
