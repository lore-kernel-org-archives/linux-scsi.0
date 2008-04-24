From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/10] qla2xxx: updates for 2.6.26 [8.02.01-k2].
Date: Thu, 24 Apr 2008 17:51:56 -0500
Message-ID: <1209077516.3121.31.camel@localhost.localdomain>
References: <20080424221945.GC4359@n8027av35btxc1.qlogic.org>
	 <1209076310.3121.26.camel@localhost.localdomain>
	 <20080424223736.GE4359@n8027av35btxc1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58060 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754855AbYDXWwA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Apr 2008 18:52:00 -0400
In-Reply-To: <20080424223736.GE4359@n8027av35btxc1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Seokmann Ju <seokmann.ju@qlogic.com>

On Thu, 2008-04-24 at 15:37 -0700, Andrew Vasquez wrote:
> On Thu, 24 Apr 2008, James Bottomley wrote:
> > On Thu, 2008-04-24 at 15:19 -0700, Andrew Vasquez wrote:
> > > This patchset contains fixes/updates for 2.6.26.
[...]
> > So, since I have to guess, I put my money on:
> > 
> > [PATCH 09/10] qla2xxx: Correct regression in relogin code
> > 
> > needs backporting to stable to fix the 2.6.24 regression bug 10486.
> > 
> > Do I win?
> 
> Sure do.  Send me your RTN and I'll wire you 10 million USD...
> 
> All kidding aside, I've just sent the patch to stable@kernel.org for
> inclusion.

Unfortunately, that won't quit work.  Stable won't accept a patch until
it's upstream.  For that reason, I tag all such patches with

Cc: Stable Tree <stable@kernel.org>

in my git tree.  This triggers an automatic email prod to the stable
team when the patch goes upstream, so unless the backport is non
trivial, that's all that's all that's needed.

I just needed to know where to put the tag.

James


