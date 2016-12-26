From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 191171] megaraid_sas fails to recognize RAID on startup, worked
 with version 4.1.20
Date: Mon, 26 Dec 2016 09:57:39 +0000
Message-ID: <bug-191171-11613-Pt8E4VTRvy@https.bugzilla.kernel.org/>
References: <bug-191171-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:57354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754829AbcLZJ5n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Dec 2016 04:57:43 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id C7E9120435
        for <linux-scsi@vger.kernel.org>; Mon, 26 Dec 2016 09:57:41 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id BC58D203ED
        for <linux-scsi@vger.kernel.org>; Mon, 26 Dec 2016 09:57:39 +0000 (UTC)
In-Reply-To: <bug-191171-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=191171

--- Comment #3 from Pierre-Alain Blanc <blancpa@worldcom.ch> ---
(In reply to kashyap from comment #2)
> (In reply to Pierre-Alain Blanc from comment #1)
> > Created attachment 248571 [details]
> > Boot with kerrnel 4.1.20 which works
> 
> You need  5e5ec1759dd6 ("scsi: megaraid_sas: fix macro MEGASAS_IS_LOGICAL to
> avoid regression") PATCH.

OK. Many thanks for your very fast reply ! 
Since my system does work with the "old" kernel, I would like to wait for the
patch to be included in next version. Is it OK for you or do you want/need me
to test the patch on the 4.1.36 ?

Note: sorry not to have posted the bug report on the openSuSE site.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
