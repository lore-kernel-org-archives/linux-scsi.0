From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 48891] scsi/lpfc/lpfc_ct.c:637: possible finger trouble ?
Date: Wed, 31 Oct 2012 19:03:04 +0000 (UTC)
Message-ID: <20121031190304.3A56E11FBE6@bugzilla.kernel.org>
References: <bug-48891-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:51379 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759793Ab2JaTDI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Oct 2012 15:03:08 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4AF21205FF
	for <linux-scsi@vger.kernel.org>; Wed, 31 Oct 2012 19:03:06 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 0E1D020607
	for <linux-scsi@vger.kernel.org>; Wed, 31 Oct 2012 19:03:05 +0000 (UTC)
In-Reply-To: <bug-48891-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=48891





--- Comment #1 from James Smart <james.smart@emulex.com>  2012-10-31 19:03:04 ---
Thank You.

This problem has been addressed by patch6 of our 8.3.36 patch kit: See 
http://marc.info/?l=linux-scsi&m=135170916626123&w=2

-- james s



On 10/17/2012 6:24 AM, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=48891
>
>
> Alan <alan@lxorguk.ukuu.org.uk> changed:
>
>             What    |Removed                     |Added
> ----------------------------------------------------------------------------
>                   CC|                            |alan@lxorguk.ukuu.org.uk
>            Component|Other                       |SCSI
>           AssignedTo|drivers_other@kernel-bugs.o |linux-scsi@vger.kernel.org
>                     |sdl.org                     |
>              Product|Drivers                     |IO/Storage
>
>
>
>

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
