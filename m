From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 79901] Extremely slow boot on Promise VTrak E610f due to sd_mod
 RSOC usage
Date: Thu, 24 Jul 2014 14:07:07 +0000
Message-ID: <bug-79901-11613-LvEuXu4SmD@https.bugzilla.kernel.org/>
References: <bug-79901-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:43165 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758932AbaGXOHQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Jul 2014 10:07:16 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id B7C94201EC
	for <linux-scsi@vger.kernel.org>; Thu, 24 Jul 2014 14:07:15 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 87527201E4
	for <linux-scsi@vger.kernel.org>; Thu, 24 Jul 2014 14:07:08 +0000 (UTC)
In-Reply-To: <bug-79901-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=79901

--- Comment #1 from Janusz Dziemidowicz <rraptorr@nails.eu.org> ---
Created attachment 144101
  --> https://bugzilla.kernel.org/attachment.cgi?id=144101&action=edit
Patch adding BLIST_NO_RSOC scsi scan flag

As discussed on the list, attached simple patch that blacklist RSOC on Promise
VTrak E610f

-- 
You are receiving this mail because:
You are the assignee for the bug.
