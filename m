From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10411] [PATCH] scsi: fix sense_slab/bio swapping livelock
Date: Mon,  7 Apr 2008 02:16:51 -0700 (PDT)
Message-ID: <20080407091651.DFEE110805F@picon.linux-foundation.org>
References: <bug-10411-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56478 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755720AbYDGJRW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Apr 2008 05:17:22 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m379GpOu026567
	for <linux-scsi@vger.kernel.org>; Mon, 7 Apr 2008 02:16:53 -0700
In-Reply-To: <bug-10411-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10411





------- Comment #1 from rjw@sisk.pl  2008-04-07 02:16 -------
James Bottomley said:

This was sort of accidentally fixed in scsi-misc by commit 

commit c5f73260b289cb974928eac05f2d84e58ddfc020
Author: James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Thu Mar 13 11:16:33 2008 -0500

    [SCSI] consolidate command allocation in a single place


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
