From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151661] Adaptec 3805 prints "AAC: Host adapter dead -1" every
 10 seconds but works fine anyway
Date: Sun, 14 Aug 2016 22:39:32 +0000
Message-ID: <bug-151661-11613-3dQOfZr7at@https.bugzilla.kernel.org/>
References: <bug-151661-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48752 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbcHNWji (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Aug 2016 18:39:38 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2BE66202DD
	for <linux-scsi@vger.kernel.org>; Sun, 14 Aug 2016 22:39:35 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id C9AEA20274
	for <linux-scsi@vger.kernel.org>; Sun, 14 Aug 2016 22:39:32 +0000 (UTC)
In-Reply-To: <bug-151661-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=151661

--- Comment #6 from David Gravereaux <davygrvy@pobox.com> ---
I'm having this same 10 second issue with a 3805 on Ubuntu 16.04 LTS with
kernel 4.4.0-34-generic

Some dmesg samplings:
$ dmesg |tail --lines=50 |grep AAC
[46793.664043] AAC: Host adapter dead -1
[46803.664049] AAC: Host adapter dead -1
[46813.664046] AAC: Host adapter dead -1
[46823.664048] AAC: Host adapter dead -1
[46833.664048] AAC: Host adapter dead -1
[46843.664053] AAC: Host adapter dead -1
[46853.664045] AAC: Host adapter dead -1
[46863.664051] AAC: Host adapter dead -1
[46873.664043] AAC: Host adapter dead -1
[46883.664052] AAC: Host adapter dead -1
[46893.664048] AAC: Host adapter dead -1
[46903.664051] AAC: Host adapter dead -1
[46913.664049] AAC: Host adapter dead -1
[46923.664046] AAC: Host adapter dead -1
[46933.664050] AAC: Host adapter dead -1
[46943.664059] AAC: Host adapter dead -1
[46953.664035] AAC: Host adapter dead -1
[46963.664047] AAC: Host adapter dead -1
[46973.664047] AAC: Host adapter dead -1
[46983.664048] AAC: Host adapter dead -1
[46993.664067] AAC: Host adapter dead -1
[47003.664044] AAC: Host adapter dead -1
[47013.664050] AAC: Host adapter dead -1
[47023.664049] AAC: Host adapter dead -1
[47033.664059] AAC: Host adapter dead -1
[47043.664062] AAC: Host adapter dead -1
[47053.664044] AAC: Host adapter dead -1
[47063.664059] AAC: Host adapter dead -1
[47073.664054] AAC: Host adapter dead -1
[47083.664062] AAC: Host adapter dead -1
[47093.664094] AAC: Host adapter dead -1
[47103.664040] AAC: Host adapter dead -1
[47113.664047] AAC: Host adapter dead -1
[47123.664046] AAC: Host adapter dead -1
[47133.664048] AAC: Host adapter dead -1
[47143.664050] AAC: Host adapter dead -1
[47153.664041] AAC: Host adapter dead -1
[47163.664039] AAC: Host adapter dead -1
[47173.664059] AAC: Host adapter dead -1
[47183.664046] AAC: Host adapter dead -1
[47193.664047] AAC: Host adapter dead -1
[47203.664070] AAC: Host adapter dead -1
[47213.664054] AAC: Host adapter dead -1
[47223.664049] AAC: Host adapter dead -1
[47233.664048] AAC: Host adapter dead -1
[47243.664062] AAC: Host adapter dead -1

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
