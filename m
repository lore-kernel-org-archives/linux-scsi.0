From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 48871] drivers/scsi/lpfc/lpfc_init.c: 2 * Buffer is accessed
 out of bounds
Date: Wed, 31 Oct 2012 19:02:14 +0000 (UTC)
Message-ID: <20121031190214.0A4C111FBAA@bugzilla.kernel.org>
References: <bug-48871-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:51313 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755439Ab2JaTCS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Oct 2012 15:02:18 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C67B12060E
	for <linux-scsi@vger.kernel.org>; Wed, 31 Oct 2012 19:02:16 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id CF9F220607
	for <linux-scsi@vger.kernel.org>; Wed, 31 Oct 2012 19:02:14 +0000 (UTC)
In-Reply-To: <bug-48871-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=48871





--- Comment #1 from James Smart <james.smart@emulex.com>  2012-10-31 19:02:13 ---
Thank You.

This problem has been addressed by patch5 of our 8.3.36 patch kit: See  
http://marc.info/?l=linux-scsi&m=135170915426118&w=2

-- james s


On 10/17/2012 6:26 AM, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=48871
>
>
> Alan <alan@lxorguk.ukuu.org.uk> changed:
>
>             What    |Removed                     |Added
> ----------------------------------------------------------------------------
>                   CC|                            |alan@lxorguk.ukuu.org.uk
>            Component|Other                       |Other
>           AssignedTo|drivers_other@kernel-bugs.o |scsi_drivers-other@kernel-b
>                     |sdl.org                     |ugs.osdl.org
>              Product|Drivers                     |SCSI Drivers
>
>
>
>

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
