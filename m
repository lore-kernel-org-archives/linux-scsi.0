From: chetan loke <loke.chetan@gmail.com>
Subject: Re: [ANNOUNCE] TCM/LIO v4.0.0-rc6 for 2.6.37-rc6
Date: Sat, 18 Dec 2010 14:13:59 -0500
Message-ID: <AANLkTimV-evsF4MFXs6JQ5H55AgtOpGrTuCdJBx9O_P=@mail.gmail.com>
References: <1292557664.31461.68.camel@haakon2.linux-iscsi.org>
	<1292599364.2820.21.camel@mulgrave.site>
	<4D0B8975.1040206@vlnb.net>
	<1292602908.2820.41.camel@mulgrave.site>
	<4D0BBE40.6030000@vlnb.net>
	<1292617658.2820.80.camel@mulgrave.site>
	<4D0BD79B.2010600@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4D0BD79B.2010600@vlnb.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: James Bottomley <James.Bottomley@suse.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "Patil, Kiran" <kiran.patil@intel.com>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Joe Eykholt <jeykholt@cisco.com>, "J.H." <warthog9@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>, Bart Van Assche <bart.vanassche@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Dec 17, 2010 at 4:35 PM, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
>
> In this regard it looks to be a good idea to freeze accepting both LIO
> and SCST until the end of the next year and then choose one with the
> biggest activity in the related mailing lists, not counting me and
> NicholasB.
>

Why wait till the end of the next year? What I proposed earlier was
'to review at the architecture level'. If folks don't agree to it then
this email drama will never
stop. Once the review starts we can decide on a common baseline to
benchmark both the stacks. I'm more than willing to test/benchmark
ESX(front-end)/SCST/LIO(back-end) combo. I'm sure there will be others
who would be willing to spend some of their time for this cause to
validate claims made by both the communities. We can then publish all
the results so that others can reproduce them.

> You want the best community, so let community choose!
>

Sure, and then we will let community choose what's best for them. And
if that means picking the best from both the worlds and coming up w/ a
unified stack then that's great!

> Vlad
> --
Chetan
