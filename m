From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 110801] Security Issure: query_disk in aacraid
Date: Thu, 14 Jan 2016 10:34:15 +0000
Message-ID: <bug-110801-11613-I3odrOFbrV@https.bugzilla.kernel.org/>
References: <bug-110801-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:43247 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385AbcANKeS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Jan 2016 05:34:18 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 84A51204AE
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jan 2016 10:34:17 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 31C1D204A2
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jan 2016 10:34:16 +0000 (UTC)
In-Reply-To: <bug-110801-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=110801

--- Comment #1 from Yong  Shi <brave_shi@163.com> ---
aachba.c

 line 2856: Calling function copy_from_user taints argument qd

 line 2858: if the attacker set the qd.cnum to -1 , the attacker could set the 
qd.cnum to anyvalue ( line 2859 qd.cnum = qd.id)

 line 2871:  Untrusted pointer read  fsa_dev_ptr[qd.cnum]

-- 
You are receiving this mail because:
You are the assignee for the bug.
