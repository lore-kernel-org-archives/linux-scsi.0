From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 64171] Block SCSI Generic Driver does not keep data
Date: Fri, 01 Nov 2013 19:52:20 +0000
Message-ID: <bug-64171-11613-dRcjlCgTZR@https.bugzilla.kernel.org/>
References: <bug-64171-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:44120 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785Ab3KATwX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Nov 2013 15:52:23 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id EC99D20437
	for <linux-scsi@vger.kernel.org>; Fri,  1 Nov 2013 19:52:22 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 47FC520481
	for <linux-scsi@vger.kernel.org>; Fri,  1 Nov 2013 19:52:21 +0000 (UTC)
In-Reply-To: <bug-64171-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=64171

--- Comment #1 from Andrew Falanga <af300wsm@gmail.com> ---
Created attachment 113051
  --> https://bugzilla.kernel.org/attachment.cgi?id=113051&action=edit
Demonstration program for BSG defect

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
