From: Nick Piggin <npiggin@suse.de>
Subject: Re: [patch] sg: simplify page_count manipulations
Date: Sat, 21 Jan 2006 11:15:43 +0100
Message-ID: <20060121101543.GB9551@wotan.suse.de>
References: <20060118155242.GB28418@wotan.suse.de> <20060118195937.3586c94f.akpm@osdl.org> <20060119144548.GF958@wotan.suse.de> <20060119140525.223a8ebf.akpm@osdl.org> <20060120101815.GD1756@wotan.suse.de> <20060120024702.6f894a13.akpm@osdl.org> <Pine.LNX.4.61.0601201623480.6415@goblin.wat.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751104AbWAUKPw@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0601201623480.6415@goblin.wat.veritas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@osdl.org>, Nick Piggin <npiggin@suse.de>, torvalds@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dougg@torque.net
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 20, 2006 at 04:32:00PM +0000, Hugh Dickins wrote:
> On Fri, 20 Jan 2006, Andrew Morton wrote:
> > 
> > I suspect nobody tried to munmap pages beyond the first one.
> > 
> > Yes, let's use a compound page in there and I expect Doug will be able to
> > test it for us sometime.
> 
> That function did move page along in 2.6.15, but has got screwed up since:
> good reason, I think, to speed Nick's patch through to clean it all away.
> 

Sorry, I'm wrong then (about the conversation around the initial patch).

Definitely restore 2.6.15 behaviour for 2.6.16 if you are hesitant to
change it. Doug's call I guess.
