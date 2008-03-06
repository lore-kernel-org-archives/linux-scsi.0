From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PATCH] SCSI bug fixes for 2.6.25-rc4
Date: Wed, 05 Mar 2008 18:39:46 -0600
Message-ID: <1204763986.3047.113.camel@localhost.localdomain>
References: <1204755977.3047.103.camel@localhost.localdomain>
	 <20080306003509.GU24386@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41478 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933372AbYCFAjt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Mar 2008 19:39:49 -0500
In-Reply-To: <20080306003509.GU24386@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Wed, 2008-03-05 at 17:35 -0700, Matthew Wilcox wrote:
> On Wed, Mar 05, 2008 at 04:26:17PM -0600, James Bottomley wrote:
> > Apart from the usual crop of bug fixes, it is hoped that both gdth
> > (under all circumstances) and aic94xx (under protocol errors) now work
> > after this.
> > 
> > The patch is available from:
> > 
> > master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
> > 
> > The short changelog is:
> 
> James, you've overlooked
> http://marc.info/?l=linux-scsi&m=119161490104667&w=2 again.  I last sent
> it to you on Feb 25th

Sorry ... the week of the 25th was a bit of a busy one.  I've tracked it
down marked it for addition.

James


