From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [0/22] Advansys updates 2007-09-09
Date: Tue, 11 Sep 2007 12:18:49 -0600
Message-ID: <20070911181849.GB21193@parisc-linux.org>
References: <20070909145358.GG6809@parisc-linux.org> <20070910051232R.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:36486 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758788AbXIKSSv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Sep 2007 14:18:51 -0400
Content-Disposition: inline
In-Reply-To: <20070910051232R.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: jens.axboe@oracle.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Tue, Sep 11, 2007 at 05:00:27AM +0900, FUJITA Tomonori wrote:
> On Sun, 9 Sep 2007 08:53:58 -0600
> Matthew Wilcox <matthew@wil.cx> wrote:
> 
> > Here's another mammoth patch series for the advansys driver against
> > scsi-misc.  I've tested that it compiles at each stage and that the
> > final result works.
> 
> This is on the top of the patchset. Can I get your ACK on it?
> 
> This depends on scsi-misc, the patchset, and sg chaining stuff.

Phew, that's one of the items on my todo list that I now don't have to
do.  Thanks!  I haven't tested it (I'm away from my machines for this
week), but please do submit it with the other sg work you've done.  Any
bugs can be figured out later.

Acked-by: Matthew Wilcox <matthew@wil.cx>

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
