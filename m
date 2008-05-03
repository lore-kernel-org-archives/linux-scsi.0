From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: modprobe aha1542 oops with git17
Date: Sat, 03 May 2008 17:23:59 -0500
Message-ID: <1209853439.3075.26.camel@localhost.localdomain>
References: <263898027@web.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:32998 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750698AbYECWYE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 May 2008 18:24:04 -0400
In-Reply-To: <263898027@web.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devzero@web.de
Cc: akpm@linux-foundation.org, jgarzik@redhat.com, rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sat, 2008-05-03 at 22:29 +0200, devzero@web.de wrote:
> this also happens on real hardware with latest git - no aha1542
> attached
> 
> didn`t happen before - looks like a regression to me

Actually, if you check with our tool sets:

http://www.kerneloops.org/search.php?search=scsi_destroy_command_freelist&btnG=Function+Search

They'll point you to the bugzilla entry:

http://bugzilla.kernel.org/show_bug.cgi?id=10598

And the fix (which is now upstream):

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=61d7416a286e840d905c18b1e6b0977c036c8656

James


