From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10846] Slow write on LSISAS1068E (SAS6/iR) on kernel >= 2.6.22
Date: Tue,  3 Jun 2008 12:21:37 -0700 (PDT)
Message-ID: <20080603192137.AFB5811D10E@picon.linux-foundation.org>
References: <bug-10846-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55981 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750818AbYFCTWc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jun 2008 15:22:32 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m53JLweJ005338
	for <linux-scsi@vger.kernel.org>; Tue, 3 Jun 2008 12:21:59 -0700
In-Reply-To: <bug-10846-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10846





------- Comment #6 from devzero@web.de  2008-06-03 12:21 -------
>So unpacking linux kernel (for example) is 5x times slower

is it really ?

does 

time tar xzvf linux-kernel.tgz ;time sync

show a noticeable difference for for 2.6.21 and for 2.6.22+ ?


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
