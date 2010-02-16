From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15288] kernel 2.6.31 loading goes in loop on IBM xSeries 330
Date: Tue, 16 Feb 2010 06:43:02 GMT
Message-ID: <201002160643.o1G6h2Hn020824@demeter.kernel.org>
References: <bug-15288-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58297 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab0BPGnF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Feb 2010 01:43:05 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1G6h2XH020828
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 16 Feb 2010 06:43:02 GMT
In-Reply-To: <bug-15288-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15288


Antti Louko <diu@mail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |diu@mail.com




--- Comment #8 from Antti Louko <diu@mail.com>  2010-02-16 06:42:55 ---
This bug also applies to kernel 2.6.32.6 (vanilla, patched with grsec) with
exactly same symptoms.

The system is IBM xSeries 220 (also Pentium III Coppermine)
01:03.0 SCSI storage controller: Adaptec AIC-7892P U160/m (rev 02)

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
