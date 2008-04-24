From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH 0/10] qla2xxx: updates for 2.6.26 [8.02.01-k2].
Date: Thu, 24 Apr 2008 15:58:47 -0700
Message-ID: <20080424225847.GG4359@n8027av35btxc1.qlogic.org>
References: <20080424221945.GC4359@n8027av35btxc1.qlogic.org> <1209076310.3121.26.camel@localhost.localdomain> <20080424223736.GE4359@n8027av35btxc1.qlogic.org> <1209077516.3121.31.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:26712 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbYDXW6w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Apr 2008 18:58:52 -0400
Content-Disposition: inline
In-Reply-To: <1209077516.3121.31.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Seokmann Ju <seokmann.ju@qlogic.com>

On Thu, 24 Apr 2008, James Bottomley wrote:

> Unfortunately, that won't quit work.  Stable won't accept a patch until
> it's upstream.  For that reason, I tag all such patches with
> 
> Cc: Stable Tree <stable@kernel.org>
> 
> in my git tree.  This triggers an automatic email prod to the stable
> team when the patch goes upstream, so unless the backport is non
> trivial, that's all that's all that's needed.
> 
> I just needed to know where to put the tag.

That's good info, thanks.  I tried to follow the bits in
Documentation/stable_kernel_rules.txt...

grazie,
av
