From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [GIT PATCH] another tranche of SCSI updates for 2.6.26
Date: Mon, 28 Apr 2008 15:24:12 +0300
Message-ID: <4815C1EC.7090109@panasas.com>
References: <1209320076.3801.26.camel@localhost.localdomain>	 <20080428013400.GA6245@elte.hu>	 <1209351113.3801.107.camel@localhost.localdomain>	 <48157B6A.60307@panasas.com> <1209384784.3367.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from DSL212-235-53-3.bb.netvision.net.il ([212.235.53.3]:56351 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932260AbYD1OsE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Apr 2008 10:48:04 -0400
In-Reply-To: <1209384784.3367.1.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Mon, Apr 28 2008 at 15:13 +0300, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Mon, 2008-04-28 at 10:23 +0300, Boaz Harrosh wrote:
>> If we are already on the subject. It looks like we always have at most 1 command in the 
>> free list, so why the free list at all? or am I reading the code wrong?
> 
> Because list handlers are well understood mechanisms within the kernel.
  This is not an excuse ;-). So is a simple pointer.
 
> Also because in low memory situations, one command per host is
> sufficient to guarantee forward progress, but it's not going to be very
> efficient.  Embedded and other low memory environments can increase the
> size of the free list to improve their I/O path.
> 

Ok that is what I thought, but inspecting the code, I can't find it. Is there
a config option or an external mechanism that let you do that? If not, is/was
there a ready made external patch that will enable such facility in someway?
Should there be one?

> James
> 

Boaz
