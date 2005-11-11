From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [GIT PATCH] final pre -rc pieces of SCSI for 2.6.14
Date: Fri, 11 Nov 2005 16:39:46 -0600
Message-ID: <43751DB2.2050509@cs.wisc.edu>
References: <1131745742.3505.47.camel@mulgrave>	 <20051111222341.GA20077@infradead.org> <1131748733.15249.1.camel@max>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751286AbVKKWku@vger.kernel.org>
In-Reply-To: <1131748733.15249.1.camel@max>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Mike Christie wrote:
> On Fri, 2005-11-11 at 22:23 +0000, Christoph Hellwig wrote:
> 
>>On Fri, Nov 11, 2005 at 03:49:01PM -0600, James Bottomley wrote:
>>
>>>  o remove scsi_wait_req
>>
>>This requires '[PATCH] kill libata scsi_wait_req usage (make libata compile in
>>scsi-misc)' from Mike, because libata started to use this function in mainline
>>about the same time it was removed in scsi-misc.
> 
> 
> 
> My previous patch needed to included scsi_eh.h. Someone sent a patch in
> -mm to d othis. Here is my patch plus the scsi_eh.h include patch rolled
> into one if you need it.
> 
> rm scsi_wait_req() usage.
> 

oh yeah that patch was made agsint scsi-misc.
