From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Wed, 30 Jan 2008 22:54:31 +0900
Message-ID: <20080130225428S.tomof@acm.org>
References: <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>
	<20080130195635T.tomof@acm.org>
	<e2e108260801300510q94bf9c8g31a0ba9d77c3c0b9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:59099 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbYA3Nyy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jan 2008 08:54:54 -0500
In-Reply-To: <e2e108260801300510q94bf9c8g31a0ba9d77c3c0b9@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bart.vanassche@gmail.com
Cc: tomof@acm.org, fujita.tomonori@lab.ntt.co.jp, rdreier@cisco.com, James.Bottomley@hansenpartnership.com, torvalds@linux-foundation.org, akpm@linux-foundation.org, vst@vlnb.net, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.orgfujita.tomonori@lab.ntt.co.jp

On Wed, 30 Jan 2008 14:10:47 +0100
"Bart Van Assche" <bart.vanassche@gmail.com> wrote:

> On Jan 30, 2008 11:56 AM, FUJITA Tomonori <tomof@acm.org> wrote:
> > On Wed, 30 Jan 2008 09:38:04 +0100
> > "Bart Van Assche" <bart.vanassche@gmail.com> wrote:
> > >
> > > Please specify which parameters you are referring to. As you know I
> >
> > Sorry, I can't say. I don't know much about iSER. But seems that Pete
> > and Robin can get the better I/O performance - line speed ratiwo with
> > STGT.
> 
> Robin Humble was using a DDR InfiniBand network, while my tests were
> performed with an SDR InfiniBand network. Robin's results can't be
> directly compared to my results.

I know that you use different hardware. I used 'ratio' word.


BTW, you said the performance difference of dio READ is 38% but I
think it's 27.3 %, though it's still large.


> Pete Wyckoff's results
> (http://www.osc.edu/~pw/papers/wyckoff-iser-snapi07-talk.pdf) are hard
> to interpret. I have asked Pete which of the numbers in his test can
> be compared with what I measured, but Pete did not reply.
> 
> > The version of OpenIB might matters too. For example, Pete said that
> > STGT reads loses about 100 MB/s for some transfer sizes for some
> > transfer sizes due to the OpenIB version difference or other unclear
> > reasons.
> >
> > http://article.gmane.org/gmane.linux.iscsi.tgt.devel/135
> 
> Pete wrote about a degradation from 600 MB/s to 500 MB/s for reads
> with STGT+iSER. In my tests I measured 589 MB/s for reads (direct
> I/O), which matches with the better result obtained by Pete.

I don't know he used the same benchmark software so I don't think that
we can compare them.

All I tried to say is the OFED version might has big effect on the
performance. So you might need to find the best one.


> Note: the InfiniBand kernel modules I used were those from the
> 2.6.22.9 kernel, not from the OFED distribution.

I'm talking about a target machine (I think that Pete was also talking
about OFED on his target machine). STGT uses OFED libraries, I think.
