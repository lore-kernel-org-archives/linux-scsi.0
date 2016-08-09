From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] ipr: Fix sync scsi scan
Date: Tue, 09 Aug 2016 16:44:07 +1000
Message-ID: <87vazaqw5k.fsf@concordia.ellerman.id.au>
References: <1470439261.2337.63.camel@HansenPartnership.com> <87popjshn6.fsf@concordia.ellerman.id.au> <11d0860f-b8dd-61a4-ac32-3ce6da208d74@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <11d0860f-b8dd-61a4-ac32-3ce6da208d74@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "aneesh.kumar@linux.vnet.ibm.com" <aneesh.kumar@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Brian King <brking@linux.vnet.ibm.com> writes:

> On 08/08/2016 05:02 AM, Michael Ellerman wrote:
>> James Bottomley <James.Bottomley@HansenPartnership.com> writes:
>> 
>>> This is seven basic fixes (plus one MAINTAINERS update) which came in
>>> close to the merge window.
>>>
>>> The patch is available here:
>>>
>>> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
>>>
>>> The short changelog is:
>>>
>>> Brian King (1):
>>>       ipr: Wait to do async scan until scsi host is initialized
>> 
>> This commit seems to be causing a ~10 minute pause during boot on my
>> powerpc boxes which have an IPR, eg:
>
> Sorry about that. I fixed up async scan and managed to break sync scan...
>
> This patch fixes it on my box. Does it fix the issue for you as well?

Yes, thanks!

If you like here's a:

Tested-by: Michael Ellerman <mpe@ellerman.id.au>


It would be good if we can we get that to Linus sooner rather than later.

cheers
