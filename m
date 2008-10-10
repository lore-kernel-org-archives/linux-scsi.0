From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] sd: remove command-size switching code
Date: Fri, 10 Oct 2008 14:10:38 -0600
Message-ID: <20081010201037.GK25780@parisc-linux.org>
References: <Pine.LNX.4.44L0.0810101559440.14173-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:35767 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761042AbYJJUKj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Oct 2008 16:10:39 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0810101559440.14173-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, Oct 10, 2008 at 04:03:20PM -0400, Alan Stern wrote:
> This patch (as1138) removes from sd.c some old code for switching from
> 10-byte commands to 6-byte commands.  This code is redundant -- the
> switching for READ and WRITE is already handled in
> scsi_io_completion() and the switching for MODE SENSE is already
> handled in scsi_mode_sense().  (There is no comparable switch for MODE
> SELECT, but I doubt one is needed.)

I noticed this odd duplication a few months ago and meant to ask about
it then, but forgot.  Thanks for cleaning this up.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
