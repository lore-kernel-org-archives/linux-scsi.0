From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 156411] scsi host6: runtime PM trying to activate child device
 host6 but parent (3-4:1.0) is not active
Date: Thu, 08 Sep 2016 21:45:41 +0000
Message-ID: <bug-156411-11613-0i2T4HDuQF@https.bugzilla.kernel.org/>
References: <bug-156411-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:57476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S938842AbcIHVpo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 8 Sep 2016 17:45:44 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id E2BE02038D
        for <linux-scsi@vger.kernel.org>; Thu,  8 Sep 2016 21:45:42 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 09DED20386
        for <linux-scsi@vger.kernel.org>; Thu,  8 Sep 2016 21:45:42 +0000 (UTC)
In-Reply-To: <bug-156411-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=156411

--- Comment #1 from Cristian Aravena Romero <caravena@gmail.com> ---
Created attachment 232721
  --> https://bugzilla.kernel.org/attachment.cgi?id=232721&action=edit
lspci -vvnn

-- 
You are receiving this mail because:
You are the assignee for the bug.
