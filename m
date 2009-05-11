From: Sachin Sant <sachinp@in.ibm.com>
Subject: Re: Next May 11 : BUG during scsi initialization
Date: Mon, 11 May 2009 21:49:55 +0530
Message-ID: <4A08502B.9040001@in.ibm.com>
References: <20090511161442.3e9d9cb9.sfr@canb.auug.org.au>  <4A081002.4050802@in.ibm.com> <20090511115233.GB8112@parisc-linux.org>  <4A081437.7000409@in.ibm.com> <20090511122135.GC8112@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20090511122135.GC8112@parisc-linux.org>
Sender: linux-next-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linuxppc-dev@ozlabs.org, Pekka Enberg <penberg@cs.helsinki.fi>, Nick Piggin <npiggin@suse.de>
List-Id: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
>> Default one. SLQB
>>
>> CONFIG_SLQB_ALLOCATOR=y
>> CONFIG_SLQB=y
>>
>> Page size is 64K with Config DEBUG_PAGEALLOC set.
>>
>> CONFIG_PPC_HAS_HASH_64K=y
>> CONFIG_PPC_64K_PAGES=y
>> CONFIG_DEBUG_PAGEALLOC=y
>>     
>
> Hm.  We've seen some similar problems at Intel while doing database
> performance tests with SLQB.  Any ideas, Nick?
>   
Yeah so the problem seems to be with SLQB. I was able to boot Next 11 with
SLUB on the same machine.

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------
