From: "Bagalkote, Sreenivas" <Sreenivas.Bagalkote@engenio.com>
Subject: RE: [PATCH resend] Allow both megaraid drivers to be built
Date: Mon, 7 Nov 2005 01:05:55 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57060CD30B@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:52207 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S964785AbVKGGHI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Nov 2005 01:07:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@SteelEye.com>, Daniel Drake <dsd@gentoo.org>
Cc: "Kolli, Neela Syam" <Neela.Kolli@engenio.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Ju, Seokmann" <Seokmann.Ju@engenio.com>

>On Sat, 2005-10-29 at 14:24 +0100, Daniel Drake wrote:
>> Here's a rediff of a patch I sent at the end of August.
>> 
>> Rename megaraid to megaraid_legacy, changing sysfs name, module
>> name, and the messages printed out via printk. I have left 
>the procfs name as
>> "megaraid" as presumably userspace tools rely on this.
>> 
>> Remove hardware ID's from megaraid_legacy which overlap with 
>the newgen
>> megaraid drivers.
>> 
>> Allow megaraid_legacy to be built alongside the newgen driver.
>> 
>> Instead of renaming the file locally and sending a huge 
>unreviewable diff, 
>> I've left the original filenames (megaraid.c and megaraid.h) 
>in place. Please 
>> use git-mv to rename these to megaraid_legacy.[ch] once you 
>have applied this.
>
>This looks fine to me.  I would, however, like input from the megaraid
>maintainers, since it actually involves a name change.  However, if
>there are no comments before we got -rc, I'll queue it for after 2.6.15
>
>James

James, the people responsible for megaraid/megaraid_mbox are collecting
information from our key customers about the impact of moving overlapping
ids. The concern, I believe, is that some customers who were exclusively
using megaraid will be forced to use megaraid_mbox. I also see that both
drivers register_chrdev() with "megadev" string. There is going to be some
impact on a stack of applications. I am not sure how Daniel's patch solved
this.

I sincerely thank Daniel Drake for kicking this issue into high gear. Please
know that this issue got the attention it needs. Getting customer feedback
wasn't very fast. How long are you willing to hold this patch?

Sreenivas
