From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 21/21] advansys: Changes to work on parisc
Date: Tue, 02 Oct 2007 23:15:01 -0400
Message-ID: <47030935.5020000@garzik.org>
References: <11913765421743-git-send-email-matthew@wil.cx> <11913765432770-git-send-email-matthew@wil.cx> <4702F7B2.7080600@garzik.org> <20071003021545.GD12049@parisc-linux.org> <4702FE4D.4030603@garzik.org> <20071003030039.GE12049@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:59462 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123AbXJCDPE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Oct 2007 23:15:04 -0400
In-Reply-To: <20071003030039.GE12049@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

Matthew Wilcox wrote:
> On Tue, Oct 02, 2007 at 10:28:29PM -0400, Jeff Garzik wrote:
>> Incorrect.  That is highly platform specific, with many using unsigned 
>> long, since the [non-x86] platform is generally pointing to a special 
>> memory region rather than directly using an x86-like instruction.
>>
>> unsigned long is the portable size to use, because it is guaranteed to 
>> work on all platforms.
>>
>> unsigned int means you exclude powerpc[64], alpha, sparc64, sh, ... 
>> it's not portable, unlike unsigned long.
> 
> I don't think that's true.  I asked a powerpc64 person about it the
> other day, and he said they don't use anything beyond the lower 32 bits.
> 
> If people are really supposed to use unsigned long, it would make sense
> to get the i386 macros changed, since they are canonical.

You're pushing against over a decade-long practice and moving into 
NAK-land...  This is the way portable drivers have always been written.

If you want to go against the grain, first change the architectures to 
not use unsigned long.  Until such time...  you know what to do :)

	Jeff



