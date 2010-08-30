From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16971] qla4xxx compile failure on 32-bit PowerPC: missing readq
 and writeq
Date: Mon, 30 Aug 2010 13:46:17 GMT
Message-ID: <201008301346.o7UDkHh0006899@demeter1.kernel.org>
References: <bug-16971-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:60758 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917Ab0H3NqS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Aug 2010 09:46:18 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o7UDkHGY006900
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 30 Aug 2010 13:46:17 GMT
In-Reply-To: <bug-16971-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16971


Florian Mickler <florian@mickler.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |florian@mickler.org




--- Comment #1 from Florian Mickler <florian@mickler.org>  2010-08-30 13:46:07 ---
On Mon, 30 Aug 2010 11:45:56 +0300 (EEST)
Meelis Roos <mroos@linux.ee> wrote:

> Still present in 2.6.36-rc3.
>

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
