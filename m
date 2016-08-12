From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151661] Adaptec 3805 prints "AAC: Host adapter dead -1" every
 10 seconds but works fine anyway
Date: Fri, 12 Aug 2016 06:17:51 +0000
Message-ID: <bug-151661-11613-tkudWWIIk5@https.bugzilla.kernel.org/>
References: <bug-151661-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:43338 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbcHLGSI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Aug 2016 02:18:08 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 50261200D0
	for <linux-scsi@vger.kernel.org>; Fri, 12 Aug 2016 06:17:55 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id C24312025B
	for <linux-scsi@vger.kernel.org>; Fri, 12 Aug 2016 06:17:51 +0000 (UTC)
In-Reply-To: <bug-151661-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=151661

--- Comment #5 from Arkadiusz Miskiewicz <arekm@maven.pl> ---
Had the same error after upgrading from 3.14.X kernel to 4.4.15

[   59.713349] AAC: Host adapter dead -1
[   69.713352] AAC: Host adapter dead -1
[   79.713347] AAC: Host adapter dead -1
[   89.713344] AAC: Host adapter dead -1
[   99.713344] AAC: Host adapter dead -1
[  109.713340] AAC: Host adapter dead -1
[  119.713341] AAC: Host adapter dead -1
[  129.713338] AAC: Host adapter dead -1
[  139.713344] AAC: Host adapter dead -1
[  149.713336] AAC: Host adapter dead -1
[  159.713336] AAC: Host adapter dead -1
[  169.713333] AAC: Host adapter dead -1
[  179.713332] AAC: Host adapter dead -1
[  189.713329] AAC: Host adapter dead -1
[  199.713331] AAC: Host adapter dead -1
[  209.713336] AAC: Host adapter dead -1
[  219.713331] AAC: Host adapter dead -1
[  229.713329] AAC: Host adapter dead -1
[  239.713332] AAC: Host adapter dead -1

Arrays were accessible. In my case it was adaptec 3405 raid card. No longer
have this system - replaced raid card with adaptec 8405 and with 8405 the
problem doesn't happen.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
