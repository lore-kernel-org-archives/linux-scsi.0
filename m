From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12163] [PATCH]mptsas driver cannot discover some hotplugged
 SATA/SAS disks
Date: Mon, 27 Apr 2009 13:55:56 GMT
Message-ID: <200904271355.n3RDtuBx020882@demeter.kernel.org>
References: <bug-12163-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:37532 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbZD0Nz5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2009 09:55:57 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n3RDtufQ020883
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2009 13:55:56 GMT
In-Reply-To: <bug-12163-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12163


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alan@lxorguk.ukuu.org.uk
     Kernel Version|mainline (2.6.28-rc6,       |2.6.28-rc6, 2.6.26.2,
                   |2.6.26.2, 2.6.22.16)        |2.6.22.16
         Regression|---                         |No
            Summary|mptsas driver cannot        |[PATCH]mptsas driver cannot
                   |discover some hotplugged    |discover some hotplugged
                   |SATA/SAS disks              |SATA/SAS disks




-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
