From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PULL] a couple of SCSI bug fixes from the last update
Date: Sat, 13 Jun 2009 15:48:56 -0500
Message-ID: <1244926136.5323.60.camel@mulgrave.site>
References: <1244915748.5323.30.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60275 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752523AbZFMUs6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Jun 2009 16:48:58 -0400
In-Reply-To: <1244915748.5323.30.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Sat, 2009-06-13 at 12:55 -0500, James Bottomley wrote:
> This just fixes up a couple of config based problems in the cnic driver
> (which is the broadcom iSCSI base).
> 
> The patch is available here:
> 
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

I was going to ask you to cancel this pull request since it has the bad
patch from Ingo in it.  However, when we get the cnic properly sorted
out, I'll include a revert for it ... the double include is harmless
until then.

James


