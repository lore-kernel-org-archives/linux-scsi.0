From: Jes Sorensen <jes@wildopensource.com>
Subject: Re: [patch] qla1280 compile fix for CONFIG_HOTPLUG in 2.6
Date: 12 Jan 2004 10:15:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <yq0k73xci67.fsf@wildopensource.com>
References: <16386.38762.670634.620111@gargle.gargle.HOWL>
	<20040112151018.A3222@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:48069 "EHLO jaguar.mkp.net")
	by vger.kernel.org with ESMTP id S265568AbUALPPU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jan 2004 10:15:20 -0500
In-Reply-To: <20040112151018.A3222@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: akpm@osdl.org, linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

Christoph> On Mon, Jan 12, 2004 at 07:47:38AM -0500, Jes Sorensen
Christoph> wrote:
>> Hi Andrew,
>> 
>> Would you mind adding this patch on top of 2.6.1-mmX. It fixes a
>> compile problem with the 1280 driver when compiling it statically
>> into the kernel when CONFIG_HOTPLUG is enabled in 2.6.

Christoph> That patch is crap.  The ifdefs are gone in -mm and that's
Christoph> the way to go.  We have __devexit and __devexitp to take
Christoph> care of that.

If that works in 2.4 fine - send me a patch please.

Jes
