From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [osd-dev] [PATCH] scsi_lib: Bug in completion of bidi commands
Date: Sun, 03 Jan 2010 12:11:46 +0200
Message-ID: <4B406D62.8060500@panasas.com>
References: <Pine.LNX.4.44L0.0912312144080.16709-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752599Ab0ACKLw@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0912312144080.16709-100000@netrider.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>, Benny Halevy <bhalevy@panasas.com>, Stable Tree <stable@kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 01/01/2010 04:46 AM, Alan Stern wrote:
> On Thu, 31 Dec 2009, Boaz Harrosh wrote:
> 
>> James hi.
>>
>> What about this BUG. It affects anybody doing bidi commands. The possibilities
>> are an sglist leak at best, and a crash at worse.
>>
>> I understand this code needs cleanup, but first things first. Lets first fix the
>> bug, which should also go to stable. Then the cleanup can go to next merge window.
>>
>> BTW: Should I attempt a cleanup on current code, or should I wait for Alan's Patch
>> to go in first?
> 
> What patch of mine are you referring to?  So far James has rejected all
> the patches I have submitted recently.  I'm going to try again in the 
> near future...
> 

OK, that's my answer, I didn't know.

Would you want that I attempt that collapsing of scsi_end_request() into scsi_io_completion
and the cleanup that implies? (that's the patch I meant.)

> Alan Stern
> 

Thanks && Happy new decade
Boaz
