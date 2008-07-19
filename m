From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11120] aacraid driver stalls on high-load SMP machines
Date: Fri, 18 Jul 2008 18:13:10 -0700 (PDT)
Message-ID: <20080719011310.6B92A10805E@picon.linux-foundation.org>
References: <bug-11120-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756207AbYGSBOH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jul 2008 21:14:07 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m6J1DbMN016247
	for <linux-scsi@vger.kernel.org>; Fri, 18 Jul 2008 18:13:38 -0700
In-Reply-To: <bug-11120-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11120





------- Comment #1 from smurf@smurf.noris.de  2008-07-18 18:13 -------
Update: my uniprocessor band-aid, besides significantly decreasing performance,
resulted in an eventual CPU soft-hang (all of them) some hours later, so this
workaround obviously doesn't.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
