From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 90601] panic on write to 3ware raid array
Date: Fri, 13 Feb 2015 16:20:58 +0000
Message-ID: <bug-90601-11613-QN7piVWcUN@https.bugzilla.kernel.org/>
References: <bug-90601-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:53981 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512AbbBMQVB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Feb 2015 11:21:01 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 94A5C20254
	for <linux-scsi@vger.kernel.org>; Fri, 13 Feb 2015 16:21:00 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id A4A7720256
	for <linux-scsi@vger.kernel.org>; Fri, 13 Feb 2015 16:20:58 +0000 (UTC)
In-Reply-To: <bug-90601-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=90601

--- Comment #12 from Alex Elsayed <eternaleye+kernelbugs@gmail.com> ---
Created attachment 166681
  --> https://bugzilla.kernel.org/attachment.cgi?id=166681&action=edit
Hardware of a second machine with the issue

Intel CPUs on an ASUS board - here's the output of lshw on the machine.

-- 
You are receiving this mail because:
You are the assignee for the bug.
