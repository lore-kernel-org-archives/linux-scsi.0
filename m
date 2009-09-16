From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14159] AIC79xx is not working properly with an attached scsi
 tape since 2.6.29
Date: Wed, 16 Sep 2009 09:16:40 GMT
Message-ID: <200909160916.n8G9Ge0V008587@demeter.kernel.org>
References: <bug-14159-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:48590 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbZIPJQh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Sep 2009 05:16:37 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n8G9Gek6008588
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2009 09:16:40 GMT
In-Reply-To: <bug-14159-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14159





--- Comment #14 from Stefan Assmann <sassmann@redhat.com>  2009-09-16 09:16:35 ---
Created an attachment (id=23100)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=23100)
skip disabling NOIOAMODE on AMD 8131 rev B1

Hi Gabriele,

could you please test again with the attached patch. I've added a check to skip
rev B1 of the AMD 8131. While looking at the code I recognized that the
DECLARE_PCI_FIXUP_* calls were missing some cases as well. So I fixed that too.
Hope this works for you.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
