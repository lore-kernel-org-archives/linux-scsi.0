From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13982] [libata] (?) causing Hardlock in 2.6.30.4 during
 simultaneous read & write
Date: Sat, 15 Aug 2009 17:45:40 GMT
Message-ID: <200908151745.n7FHje4D008131@demeter.kernel.org>
References: <bug-13982-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:52998 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbZHORpj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Aug 2009 13:45:39 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n7FHjetP008132
	for <linux-scsi@vger.kernel.org>; Sat, 15 Aug 2009 17:45:40 GMT
In-Reply-To: <bug-13982-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13982


David Hill <hilld@binarystorm.net> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |hilld@binarystorm.net




--- Comment #5 from David Hill <hilld@binarystorm.net>  2009-08-15 17:45:39 ---
Same network card as in bug 13219

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
