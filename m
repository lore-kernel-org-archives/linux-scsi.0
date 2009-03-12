From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] SCSI: increase default timeout for INQUIRY
Date: Thu, 12 Mar 2009 09:12:06 -0600
Message-ID: <20090312151206.GC14425@parisc-linux.org>
References: <Pine.LNX.4.44L0.0903121106480.3155-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:36374 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376AbZCLPMY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Mar 2009 11:12:24 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0903121106480.3155-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Paul Wellner Bou <paul@purecodes.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, Mar 12, 2009 at 11:08:51AM -0400, Alan Stern wrote:
> It's hard to see how this could cause any signficant problems, unless 
> somebody actually depends on INQUIRY timing out.

Erm, like doing a scan of a bus?  With 15 devices to probe, you've
increased the time from 15 * 3 = 45 seconds to 15 * 20 = 300 seconds.
That's not cool ;-(

Maybe we could default this in the transport or something so USB can
override it.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
