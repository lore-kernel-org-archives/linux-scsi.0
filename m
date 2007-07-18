From: Geoff Levand <geoffrey.levand@am.sony.com>
Subject: Re: PS3: sg chaining support
Date: Wed, 18 Jul 2007 14:08:31 -0700
Message-ID: <469E814F.7040303@am.sony.com>
References: <Pine.LNX.4.62.0707171806100.29326@pademelon.sonytel.be> <469D3224.50608@am.sony.com> <20070718063357.GK5625@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:54343 "EHLO
	outbound5-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761021AbXGRVJK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jul 2007 17:09:10 -0400
In-Reply-To: <20070718063357.GK5625@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, linux-scsi@vger.kernel.org

Jens Axboe wrote:
> On Tue, Jul 17 2007, Geoff Levand wrote:
>> I'm wondering what the status of this work is.  The patch I've
>> seen no longer applies to ps3/system-bus.c.  A rebase to
>> linux-2.6.git a5fcaa210626a79465321e344c91a6a7dc3881fa is below,
>> but untested, as I don't have the other patches to do the build.
> 
> I rebased the tree yesterday to resolve that conflict, it's in the
> sglist-arch branch now. The result is identical to yours.
> 
> Shall I take this as an acked-by?
> 

I did some casual testing on PS3 with linux-2.6-block.git #sglist-arch
7c132dd2c151dd559baa64abae7a39e9e9a82f28 and it seems to work OK.

Acked-by: Geoff Levand <geoffrey.levand@am.sony.com>


