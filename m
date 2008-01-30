From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Wed, 30 Jan 2008 14:10:47 +0100
Message-ID: <e2e108260801300510q94bf9c8g31a0ba9d77c3c0b9@mail.gmail.com>
References: <adazluoe2t3.fsf@cisco.com>
	 <20080130083239E.fujita.tomonori@lab.ntt.co.jp>
	 <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>
	 <20080130195635T.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.235]:4557 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbYA3NKu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jan 2008 08:10:50 -0500
Received: by wr-out-0506.google.com with SMTP id c48so94812wra.23
        for <linux-scsi@vger.kernel.org>; Wed, 30 Jan 2008 05:10:48 -0800 (PST)
In-Reply-To: <20080130195635T.tomof@acm.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: fujita.tomonori@lab.ntt.co.jp, rdreier@cisco.com, James.Bottomley@hansenpartnership.com, torvalds@linux-foundation.org, akpm@linux-foundation.org, vst@vlnb.net, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org

On Jan 30, 2008 11:56 AM, FUJITA Tomonori <tomof@acm.org> wrote:
> On Wed, 30 Jan 2008 09:38:04 +0100
> "Bart Van Assche" <bart.vanassche@gmail.com> wrote:
> >
> > Please specify which parameters you are referring to. As you know I
>
> Sorry, I can't say. I don't know much about iSER. But seems that Pete
> and Robin can get the better I/O performance - line speed ratio with
> STGT.

Robin Humble was using a DDR InfiniBand network, while my tests were
performed with an SDR InfiniBand network. Robin's results can't be
directly compared to my results.

Pete Wyckoff's results
(http://www.osc.edu/~pw/papers/wyckoff-iser-snapi07-talk.pdf) are hard
to interpret. I have asked Pete which of the numbers in his test can
be compared with what I measured, but Pete did not reply.

> The version of OpenIB might matters too. For example, Pete said that
> STGT reads loses about 100 MB/s for some transfer sizes for some
> transfer sizes due to the OpenIB version difference or other unclear
> reasons.
>
> http://article.gmane.org/gmane.linux.iscsi.tgt.devel/135

Pete wrote about a degradation from 600 MB/s to 500 MB/s for reads
with STGT+iSER. In my tests I measured 589 MB/s for reads (direct
I/O), which matches with the better result obtained by Pete.

Note: the InfiniBand kernel modules I used were those from the
2.6.22.9 kernel, not from the OFED distribution.

Bart.
