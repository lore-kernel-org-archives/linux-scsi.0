From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 85751] iSCSI initiator lockup during logout
Date: Tue, 07 Oct 2014 18:34:54 +0000
Message-ID: <bug-85751-11613-Ppgo0MWppo@https.bugzilla.kernel.org/>
References: <bug-85751-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:56552 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754939AbaJGSe5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Oct 2014 14:34:57 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A056920225
	for <linux-scsi@vger.kernel.org>; Tue,  7 Oct 2014 18:34:56 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 2DA1520220
	for <linux-scsi@vger.kernel.org>; Tue,  7 Oct 2014 18:34:55 +0000 (UTC)
In-Reply-To: <bug-85751-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=85751

--- Comment #3 from Bart Van Assche <bvanassche@acm.org> ---
On 10/07/14 19:03, Mike Christie wrote:
> On 10/07/2014 11:42 AM, bugzilla-daemon@bugzilla.kernel.org wrote:
>> * iscsiadm -m discovery -p 192.168.1.124 -t st
>> * iscsiadm -m node -p 192.168.1.124 -l
>> (something went wrong at the target side and the iSCSI initiator tried to
>> relogin)
>
> Did this login command ever complete normally? Did you ctrl-c it or did
> you run the logout command below in another terminal?

Hello Mike,

Thanks for jumping in. I had indeed interrupted login via Ctrl-C because 
login took longer than expected.

Bart.

-- 
You are receiving this mail because:
You are the assignee for the bug.
