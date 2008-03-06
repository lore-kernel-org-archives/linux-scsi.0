From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [GIT PATCH] SCSI bug fixes for 2.6.25-rc4
Date: Wed, 5 Mar 2008 17:35:09 -0700
Message-ID: <20080306003509.GU24386@parisc-linux.org>
References: <1204755977.3047.103.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:37167 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531AbYCFAfM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Mar 2008 19:35:12 -0500
Content-Disposition: inline
In-Reply-To: <1204755977.3047.103.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Wed, Mar 05, 2008 at 04:26:17PM -0600, James Bottomley wrote:
> Apart from the usual crop of bug fixes, it is hoped that both gdth
> (under all circumstances) and aic94xx (under protocol errors) now work
> after this.
> 
> The patch is available from:
> 
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
> 
> The short changelog is:

James, you've overlooked
http://marc.info/?l=linux-scsi&m=119161490104667&w=2 again.  I last sent
it to you on Feb 25th

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
