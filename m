From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12893] Race condition can cause two devices to get assigned the same device minor number.
Date: Thu, 19 Mar 2009 04:42:39 -0700 (PDT)
Message-ID: <20090319114239.67E2110800E@picon.linux-foundation.org>
References: <bug-12893-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47969 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751614AbZCSLns (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Mar 2009 07:43:48 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n2JBgdEp006115
	for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2009 04:43:15 -0700
In-Reply-To: <bug-12893-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12893


alan@lxorguk.ukuu.org.uk changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |CLOSED
         Resolution|                            |PATCH_ALREADY_AVAILABLE




-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
