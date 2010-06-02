From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 0/7] SCSI: trivial cleanups
Date: Wed, 2 Jun 2010 16:35:07 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1006021619530.1330-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:58682 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752166Ab0FBUfI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2010 16:35:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James:

The following patches implement a bunch of really minor cleanups in the
SCSI midlayer, stuff I ran across while doing other work.  They do
things like improve the text of an error message, remove an unnecessary
local variable, move some code from a subroutine up into its caller,
and so on.

Only the last patch makes a semantic change, and IIRC it is something
you have already agreed was a reasonable thing to do: make the
reap_ref field in scsi_target behave more like a count of the number of
devices under the target.  Overall there shouldn't be any changes in
behavior.

These patches aren't geared toward making the kernel better, faster, 
more reliable, or anything like that.  Their purpose simply is to make 
the source code a little easier to read and understand.

There shouldn't be anything objectionable in any of these.  Please let 
me know either way; if you don't like something I'll probably just 
withdraw it, and if you decide to apply these toward linux-next then 
I'll know not to pester you about them.

Alan Stern

