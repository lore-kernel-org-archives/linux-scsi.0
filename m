From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: Conversion to generic boolean
Date: Tue, 29 Aug 2006 11:15:23 +1000
Message-ID: <44F3952B.5000500@yahoo.com.au>
References: <44EFBEFA.2010707@student.ltu.se>	<20060828093202.GC8980@infradead.org> <20060828171804.09c01846.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:14956 "HELO
	smtp103.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1750776AbWH2BPv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Aug 2006 21:15:51 -0400
In-Reply-To: <20060828171804.09c01846.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Christoph Hellwig <hch@infradead.org>, Richard Knutsson <ricknu-0@student.ltu.se>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 28 Aug 2006 10:32:02 +0100
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> 
>>On Sat, Aug 26, 2006 at 05:24:42AM +0200, Richard Knutsson wrote:
>>
>>>Hello
>>>
>>>Just would like to ask if you want patches for:
>>
>>Total NACK to any of this boolean ididocy.  I very much hope you didn't
>>get the impression you actually have a chance to get this merged.
> 
> 
> I was kinda planning on merging it ;)
> 
> I can't say that I'm in love with the patches, but they do improve the
> situation.
> 
> At present we have >50 different definitions of TRUE and gawd knows how
> many private implementations of various flavours of bool.
> 
> In that context, Richard's approach of giving the kernel a single
> implementation of bool/true/false and then converting things over to use it
> makes sense.  The other approach would be to go through and nuke the lot,
> convert them to open-coded 0/1.

Well... we are programming in C here, aren't we ;)

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 

