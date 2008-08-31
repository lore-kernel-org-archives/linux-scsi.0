From: Simon Arlott <simon@fire.lp0.eu>
Subject: Re: [PATCH] scsi/sd: Fix capacity output to show MB/GB/TB/...
Date: Sun, 31 Aug 2008 16:04:38 +0100
Message-ID: <48BAB306.4050207@simon.arlott.org.uk>
References: <48B9546B.4010004@simon.arlott.org.uk> <1220147947.3615.18.camel@localhost.localdomain> <20080831025412.GJ1239@parisc-linux.org> <200808311625.15655.ioe-lkml@rameria.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753189AbYHaPE6@vger.kernel.org>
In-Reply-To: <200808311625.15655.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Oeser <ioe-lkml@rameria.de>
Cc: Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 31/08/08 15:25, Ingo Oeser wrote:
> Hi Matthew,
> 
> On Sunday 31 August 2008, Matthew Wilcox wrote:
>> BTW, I do appreciate Simon's point about df showing a different number.
>> How about we print:
>> 
>> sd 7:0:0:0: [sdc] 1099511627776 512-byte hardware sectors (563TB / 512TiB)
>> 
>> (or perhaps a more realistic number ...)
>> 
>> sd 7:0:0:0: [sdc] 976562500000 512-byte hardware sectors (500TB / 455TiB)
>> 
>> It's perhaps a more gentle way of informing our users that they may not
>> have quite as much capacity as they thought they had.
> 
> Great idea! As a user/admin I would find this the best one of all.
> 
> 1. All variants given.
> 2. Correct scientific units used.

I oppose all the "iB" forms. Has anyone tried pronouncing these?
Pee-bee-bytes?

Alternatively we could just remove the part in brackets from the message...

-- 
Simon Arlott
