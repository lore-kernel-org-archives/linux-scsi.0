From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 6868] Crash with Nat consumption in sg_add
Date: Wed, 26 Mar 2008 07:43:54 -0700 (PDT)
Message-ID: <20080326144354.F2F8411D109@picon.linux-foundation.org>
References: <bug-6868-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752622AbYCZOo0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Mar 2008 10:44:26 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m2QEhttV006984
	for <linux-scsi@vger.kernel.org>; Wed, 26 Mar 2008 07:43:56 -0700
In-Reply-To: <bug-6868-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=6868





------- Comment #4 from anonymous@kernel-bugs.osdl.org  2008-03-26 07:43 -------
Reply-To: James.Bottomley@HansenPartnership.com

On Wed, 2008-03-26 at 02:07 -0700, bugme-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=6868

> ------- Comment #3 from protasnb@gmail.com  2008-03-26 02:07 -------
> If the patch is still needed, please submit it to LKML, otherwise it won't be
> reviewed/picked up. 

I can certainly promise you that the patch won't apply:  The sg_dev_arr
was removed by this:

commit 7c07d613d22680f1caf2bd9ee49838ec7730b9da
Author: James Bottomley <James.Bottomley@steeleye.com>
Date:   Sun Aug 5 13:36:11 2007 -0500

    [SCSI] sg: use idr to replace static arrays

However, since the root cause is an unhandled failure of
class_device_add, I think it has been fixed by this:

commit d07e03610ca1f4be373f32ad5b25ac00dbdb867d
Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date:   Tue Jan 15 13:18:00 2008 +0900

    [SCSI] sg: handle class_device_create failure properly

James


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
