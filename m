From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 7717] Tapes unreadable after unload
Date: Wed, 16 Apr 2008 00:43:19 -0700 (PDT)
Message-ID: <20080416074319.A5AB910805E@picon.linux-foundation.org>
References: <bug-7717-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750874AbYDPHnV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Apr 2008 03:43:21 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m3G7hJx8031333
	for <linux-scsi@vger.kernel.org>; Wed, 16 Apr 2008 00:43:21 -0700
In-Reply-To: <bug-7717-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=7717





------- Comment #12 from bgs@bgs.hu  2008-04-16 00:43 -------
 I can only rely on previous data as my company after seeing 400GBs lost
decided to switch to w2k3. I managed to save one of the copies of the bad tape.
I gave it to some IBM guys in Scotland and they confirmed that there is an EOD
on the tape, but they could not rewrite it. Normal LTO specs forbids doing
anything beyond it. I would need a hacked LTO firmware to be able to overwrite
the EOD. From there I could raw read the tape and recover the data. 

 Right now the case seems hopeless though.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
