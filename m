From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15185] Sending a 48bit ATA-Command with "CheckCondition"
 through SG_IO does not return correct 48bit sense descriptor
Date: Tue, 9 Feb 2010 16:13:29 GMT
Message-ID: <201002091613.o19GDTSn011406@demeter.kernel.org>
References: <bug-15185-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:56437 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab0BIQNa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2010 11:13:30 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o19GDT5j011414
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 9 Feb 2010 16:13:30 GMT
In-Reply-To: <bug-15185-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15185


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |alan@lxorguk.ukuu.org.uk
          Component|Other                       |Serial ATA
         Resolution|                            |CODE_FIX
         AssignedTo|scsi_drivers-other@kernel-b |jgarzik@pobox.com
                   |ugs.osdl.org                |
            Product|SCSI Drivers                |IO/Storage




--- Comment #4 from Alan <alan@lxorguk.ukuu.org.uk>  2010-02-09 16:13:13 ---
commit bc496ed00ab1411d3efaf295b72e0c9eb343e1a3

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
