From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10861] 2.6.26-rc4-git2 - long pause during boot
Date: Thu,  5 Jun 2008 14:51:41 -0700 (PDT)
Message-ID: <20080605215141.4FA49108046@picon.linux-foundation.org>
References: <bug-10861-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42317 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752587AbYFEVwL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jun 2008 17:52:11 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m55Lpfm8021760
	for <linux-scsi@vger.kernel.org>; Thu, 5 Jun 2008 14:51:42 -0700
In-Reply-To: <bug-10861-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10861





------- Comment #2 from anonymous@kernel-bugs.osdl.org  2008-06-05 14:51 -------
Reply-To: James.Bottomley@HansenPartnership.com

On Thu, 2008-06-05 at 14:26 -0700, bugme-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=10861
> 
> 
> 
> 
> 
> ------- Comment #1 from rjw@sisk.pl  2008-06-05 14:26 -------
> Caused by:
> 
> commit b0ed43360fdca227048d88a08290365cb681c1a8
> Author: Hannes Reinecke <hare@suse.de>
> Date:   Tue Mar 18 14:32:28 2008 +0100
> 
>     [SCSI] add scsi_host and scsi_target to scsi_bus
> 
>     Signed-off-by: Hannes Reinecke <hare@suse.de>
>     Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
>     Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

This looks like another manifestation of the bus_uevent problem ... does
2.6.26-rc5 work OK?

James


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
