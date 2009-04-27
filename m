From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13143] scsi_debug doesn't manage more than 1Tb
Date: Mon, 27 Apr 2009 10:41:00 GMT
Message-ID: <200904271041.n3RAf0XT000556@demeter.kernel.org>
References: <bug-13143-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34043 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbZD0KlB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2009 06:41:01 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n3RAf0DN000557
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2009 10:41:00 GMT
In-Reply-To: <bug-13143-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13143





--- Comment #4 from Thierry Vignaud <tvignaud@mandriva.com>  2009-04-27 10:39:15 ---
(In reply to comment #1)
> it seems invalid that you tested linux 2.5 ?

Version was auto filled by bugzilla. Really was 2.6.29.1

> And could you describe it more detailed as in REPORTING-BUGS ?

All needed data was provided in initial comment. And it was enough in order to
provide a fix.

> I have also ITB disks and it cannot reproduce. Thanks.

It's not about 1Tb disks but about the scsi_debug driver.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
