From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.20.3: kernel BUG at mm/slab.c:597 try#2
Date: Sun, 18 Mar 2007 22:00:06 -0800
Message-ID: <20070318220006.7230fd58.akpm@linux-foundation.org>
References: <45FDDA8E.8030100@domdv.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43610 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965638AbXCSGA2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Mar 2007 02:00:28 -0400
In-Reply-To: <45FDDA8E.8030100@domdv.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Steinmetz <ast@domdv.de>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Mon, 19 Mar 2007 01:34:22 +0100 Andreas Steinmetz <ast@domdv.de> wrote:

> As posted to lkml and linux-scsi on 2007-03-15 without reply, see
> http://marc.info/?l=linux-kernel&m=117395128412313&w=2 for original post:

Repeatable oops in our most recently released kernel, nobody bothers to
reply.

> It is not so nice when one can write backup tapes but the tapes cannot
> be read. I don't know if memory management or the st driver is the
> culprit, but this is a not so nice situation.
> 
> I can't even say if the tapes are written correctly as I can't read them
> (one does not reboot production machines back to 2.4.x just to try to
> read a backup tape - I don't have 2.6.x older than 2.6.20 on these
> machines).

        BUG_ON(!PageSlab(page));

that's seriously screwed up.  Do you have CONFIG_DEBUG_SLAB enabled?  If
not, please enable it and retest.

