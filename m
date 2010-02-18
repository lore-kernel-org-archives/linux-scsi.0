From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15288] kernel 2.6.31 loading goes in loop on IBM xSeries 330
Date: Thu, 18 Feb 2010 03:20:43 GMT
Message-ID: <201002180320.o1I3KhQU031006@demeter.kernel.org>
References: <bug-15288-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38253 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab0BRDUo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2010 22:20:44 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1I3KiXd031008
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 18 Feb 2010 03:20:44 GMT
In-Reply-To: <bug-15288-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15288


Andrew Morton <akpm@linux-foundation.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
          Component|Other                       |Config-Interrupts
         AssignedTo|scsi_drivers-other@kernel-b |acpi_config-interrupts@kern
                   |ugs.osdl.org                |el-bugs.osdl.org
            Product|SCSI Drivers                |ACPI




-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
