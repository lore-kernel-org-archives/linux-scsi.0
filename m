From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC 1/2] block: implement an unprep function corresponding directly
 to prep
Date: Mon, 05 Jul 2010 18:00:28 -0400
Message-ID: <4C3255FC.9060503@garzik.org>
References: <1277917264.2839.153.camel@mulgrave.site> <20100701104653O.fujita.tomonori@lab.ntt.co.jp> <20100702110343.GA27159@lst.de> <20100705160023S.fujita.tomonori@lab.ntt.co.jp> <20100705192413.GA24189@lst.de> <4C3253C0.8040900@teksavvy.com> <4C3254A3.6080709@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47871 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789Ab0GEWAb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jul 2010 18:00:31 -0400
In-Reply-To: <4C3254A3.6080709@teksavvy.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <kernel@teksavvy.com>
Cc: Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James.Bottomley@suse.de, snitzer@redhat.com, axboe@kernel.dk, linux-scsi@vger.kernel.org, dm-devel@redhat.com, linux-ide@vger.kernel.org

On 07/05/2010 05:54 PM, Mark Lord wrote:
>> On 05/07/10 03:24 PM, Christoph Hellwig wrote:
>>>
>>> What codebase were you testing on? Sorry, but curently I'm a bit lost
>>> in the maze of patches. I've got both and intel and an OCZ SSD
> ..
>
> Do you, or anyone else with one, know what the upper limit is on
> TRIM operations with the Intel SSDs ?
>
> I need to know the maximum amount of TRIM ranges they will process
> in a single command.
>
> Eg. Indilinx-based SSDs don't appear to have a limit -- they'll accept
> a TRIM command with thousands of LBA ranges included.
>
> Sandforce-based SSDs appear to restrict things to max 4KB of range data.
>
> So.. what about Intel?

Lovely :(  I wonder if we could test for that limit at mke2fs time, or 
similar.

Seeing a 4k limit on other SSDs would not surprise me.  Or even a 512-b 
limit.

	Jeff



