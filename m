From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] Add proper module ID tables to Adaptec aic7[9x]xx drivers
Date: Thu, 07 Oct 2004 16:42:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4165AA1A.1020708@adaptec.com>
References: <linux.scsi.20040621161047.GD16453@master.mivlgu.local> <41644BD5.7030807@tls.msk.ru> <20041006202543.GA22794@wotan.suse.de> <4165862E.1040904@adaptec.com> <4165950C.509@tls.msk.ru> <41659D30.7050705@adaptec.com> <20041007213612.A17286@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:36256 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S268158AbUJGUmM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2004 16:42:12 -0400
In-Reply-To: <20041007213612.A17286@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Michael Tokarev <mjt@tls.msk.ru>, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Thu, Oct 07, 2004 at 03:46:56PM -0400, Luben Tuikov wrote:
> 
>>Michael Tokarev wrote:
>>
>>>Luben Tuikov wrote:
>>>
>>>
>>>>Andi Kleen wrote:
>>>>
>>>
>>>[]
>>>
>>>
>>>>>Luben, can you just do a proper pci_id table please? You probably
>>>>>know the requirements best.
>>>>
>>>>
>>>>Yes, no problem. (It'd be tricky but I'll try to augment it properly.)
>>>
>>>
>>>Christoph Hellwig already did that, it seems --
>>>see his post to linux-scsi dated Sep-12,
>>>http://marc.theaimsgroup.com/?m=109500574722283
>>
>>Yes, I forgot about this one -- this is pretty much what I
>>had intended to do.
> 
> 
> The version had a few bugs unfortunately.  For various HP boards
> I mixed up vendor and subvendor id, and the raid boards are completely
> missing.  I tried to fix that up but got totally lost in the various ids.
> 
> If there's a completely list of AIC79XX board variants I could try again.

Ah, ok -- I was wondering.

Well, it's not as easy as dumping the list into a table.
Let me try to come up with something here.

	Luben


