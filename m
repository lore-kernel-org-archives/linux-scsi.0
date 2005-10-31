From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Latest update to scsi-misc-2.6
Date: Mon, 31 Oct 2005 11:32:28 -0600
Message-ID: <1130779948.3293.35.camel@mulgrave>
References: <1130778840.24530.20.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:2972 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964803AbVJaRcj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Oct 2005 12:32:39 -0500
In-Reply-To: <1130778840.24530.20.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2005-10-31 at 09:13 -0800, Mark Haverkamp wrote:
> I updated my local scsi-misc-2.6 tree today and had merge conflicts
> somehow.  The tree had not been previously locally modified and was up
> to date as of last week.  I used the cg-update command to perform the
> update.  After receiving the changes it got a merge conflict:
> 
> Applying changes...
> Merging fe607aa94f5d25ee84f9a9a4fdf2cce3765e12e4 -> d078650986b117520f2b10cb72c04bc1904e3ba7
>         to a25bbd9e2f6c6907672301fe934a8f9989e60330...
> ... Auto-merging drivers/scsi/scsi_scan.c
> merge: warning: conflicts during merge

My best guess is that your merge programme is confused.  I've had to
merge the tree up several times to fix conflicts, but it's the same
tree.  It looks like whatever tool you used to merge failed to recognise
this.

James


