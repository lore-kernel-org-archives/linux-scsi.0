From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 95101] scsi/mpt2sas: setpci reset results in kernel oops
Date: Thu, 19 Mar 2015 17:33:56 +0000
Message-ID: <bug-95101-11613-IjqRa8Dy8T@https.bugzilla.kernel.org/>
References: <bug-95101-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48186 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313AbbCSReD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Mar 2015 13:34:03 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3DFCC2050B
	for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2015 17:34:02 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id D5D16204FC
	for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2015 17:33:56 +0000 (UTC)
In-Reply-To: <bug-95101-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=95101

Nagarajkumar N <nagarajkumar.narayanan@seagate.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |linux-scsi@vger.kernel.org,
                   |                            |nagarajkumar.narayanan@seag
                   |                            |ate.com

-- 
You are receiving this mail because:
You are on the CC list for the bug.
