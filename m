From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: Re: [ANNOUNCE] scsi patch queue tree
Date: Wed, 28 May 2014 21:31:14 +0530
Message-ID: <5386084A.6030003@codeaurora.org>
References: <20140519140614.GA12183@infradead.org> <20140520100343.31490551@canb.auug.org.au> <20140520053928.GA1751@infradead.org> <20140521094636.515289e8@canb.auug.org.au> <1400639101.2481.19.camel@dabdike> <20140528105429.GA20549@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140528105429.GA20549@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 5/28/2014 4:24 PM, Christoph Hellwig wrote:
> I've pushed the following changes to the drivers-for-3.16 tree.  I've
> there's anyting matching the rules that I did forget please resend
> and/or ping me.
>
>
> ----------------------------------------------------------------
> Benoit Taine (2):
>        qla4xxx: Use kmemdup instead of kmalloc + memcpy
>        qla2xxx: Use kmemdup instead of kmalloc + memcpy
>
> Dan Carpenter (1):
>        qla2xxx: fix incorrect debug printk
>
> Dolev Raviv (4):
>        scsi: ufs: query descriptor API
>        scsi: ufs: device query status and size check
>        scsi: ufs: Logical Unit (LU) command queue depth
>        scsi: ufs: Fix queue depth handling for best effort cases

The above 4 patches are just posted to mailing lists with no
review/ack's yet. I believe it still went in because the sender has
modified the author name to himself and signed-off by is present by the
original author which worked as a positive review for your rules. I
have asked the sender to check why the original author name is changed.
Meanwhile, I believe these patches should get some more time for review.


-- 
Regards,
Sujit
