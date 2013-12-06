From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 66611] Very Slow I/O performance on SAS1064
Date: Fri, 06 Dec 2013 12:48:41 +0000
Message-ID: <bug-66611-11613-il7rXr8NTX@https.bugzilla.kernel.org/>
References: <bug-66611-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:52439 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402Ab3LFMsp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Dec 2013 07:48:45 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3A38120528
	for <linux-scsi@vger.kernel.org>; Fri,  6 Dec 2013 12:48:44 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 11B46204FB
	for <linux-scsi@vger.kernel.org>; Fri,  6 Dec 2013 12:48:42 +0000 (UTC)
In-Reply-To: <bug-66611-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=66611

--- Comment #2 from Markus <mar@kola.li> ---
[76030.662354] sd 2:0:0:0: [sda] CDB:
[76030.708275] Synchronize Cache(10): 35 00 00 00 00 00 00 00 00 00
[76032.423998] mptscsih: ioc0: task abort: SUCCESS (rv=2002)
(sc=fffff8137f45fda0)
[76132.695517] mptscsih: ioc0: attempting task abort! (sc=fffff8137f4049a0)

-- 
You are receiving this mail because:
You are the assignee for the bug.
