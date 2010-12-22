From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [ANNOUNCE] TCM/LIO v4.0.0-rc6 for 2.6.37-rc6
Date: Wed, 22 Dec 2010 18:28:00 +0300
Message-ID: <4D121900.2000404@vlnb.net>
References: <1292557664.31461.68.camel@haakon2.linux-iscsi.org>	<1292599364.2820.21.camel@mulgrave.site>	<4D0B8975.1040206@vlnb.net>	<1292602908.2820.41.camel@mulgrave.site>	<4D0BBE40.6030000@vlnb.net>	<1292617658.2820.80.camel@mulgrave.site>	<4D0BD79B.2010600@vlnb.net> <AANLkTimV-evsF4MFXs6JQ5H55AgtOpGrTuCdJBx9O_P=@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:57466 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab0LVP3B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Dec 2010 10:29:01 -0500
In-Reply-To: <AANLkTimV-evsF4MFXs6JQ5H55AgtOpGrTuCdJBx9O_P=@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: chetan loke <loke.chetan@gmail.com>
Cc: James Bottomley <James.Bottomley@suse.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "Patil, Kiran" <kiran.patil@intel.com>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Joe Eykholt <jeykholt@cisco.com>, "J.H." <warthog9@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>, Bart Van Assche <bart.vanassche@gmail.com>

chetan loke, on 12/18/2010 10:13 PM wrote:
> On Fri, Dec 17, 2010 at 4:35 PM, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
>>
>> In this regard it looks to be a good idea to freeze accepting both LIO
>> and SCST until the end of the next year and then choose one with the
>> biggest activity in the related mailing lists, not counting me and
>> NicholasB.
> 
> Why wait till the end of the next year? What I proposed earlier was
> 'to review at the architecture level'. If folks don't agree to it then
> this email drama will never
> stop. Once the review starts we can decide on a common baseline to
> benchmark both the stacks. I'm more than willing to test/benchmark
> ESX(front-end)/SCST/LIO(back-end) combo. I'm sure there will be others
> who would be willing to spend some of their time for this cause to
> validate claims made by both the communities. We can then publish all
> the results so that others can reproduce them.

This will be exactly what we need: an open and fair comparison. But the
problem is that James doesn't want any comparisons. He doesn't consider
them important. Only personality of the code submitter is important for
James.

Vlad
