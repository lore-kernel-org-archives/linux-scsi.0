From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [GIT PATCH] scsi bug fixes for 2.6.23-rc2
Date: Tue, 7 Aug 2007 22:58:24 +0900
Message-ID: <20070806162823P.tomof@acm.org>
References: <alpine.LFD.0.999.0708061748240.5037@woody.linux-foundation.org>
	<1186458941.6637.44.camel@localhost.localdomain>
	<20070807001429.f8cb3b22.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:44257 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759999AbXHGN6g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Aug 2007 09:58:36 -0400
In-Reply-To: <20070807001429.f8cb3b22.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@SteelEye.com, torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 7 Aug 2007 00:14:29 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 06 Aug 2007 22:55:41 -0500 James Bottomley <James.Bottomley@SteelEye.com> wrote:
> 
> > The real root cause of all of this is that there's no tree I can
> > persuade all the interested parties to test that includes all of these
> > features.  In spite of the fact they've all been incubating in -mm for
> > at least 3 months, no-one apparently tested all the features together
> > until 2.6.23-rc1 was released, so then we're scrambling to address the
> > issues as they arise.
> 
> I pulled git-scsi-misc on July 19 and there was no bsg code in there at
> all.  I pulled again on July 20 and all the bsg code was in mainline.  So
> it appears that the bsg code went mailing-list -> mainline in less than 24
> hours, so there wasn't a lot of opportunity for -mm testing there.

bsg was merged via Jens' branch. After that, I asked James to send
some fixes via the scsi-rc-fixes.


> A lot of the stupid it-doesn't-compile stuff would have been fixed in -mm,
> but more substantial problems might not have been picked up.  But one can
> say that about anything.

My mistake. I should have sent bsg to -mm. Sorry about that.
