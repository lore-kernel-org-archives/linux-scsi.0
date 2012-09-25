From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [SCSI PATCH] sd: max-retries becomes configurable
Date: Tue, 25 Sep 2012 01:21:54 -0400
Message-ID: <50613F72.4000302@pobox.com>
References: <20120924210049.GA18527@havoc.gtf.org> <1348546019.2457.3.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1348546019.2457.3.camel@dabdike>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 09/25/2012 12:06 AM, James Bottomley wrote:
> On Mon, 2012-09-24 at 17:00 -0400, Jeff Garzik wrote:
>>
>>   drivers/scsi/sd.c |    4 ++++
>>   drivers/scsi/sd.h |    2 +-
>>   2 files changed, 5 insertions(+), 1 deletion(-)
>
> I'm not opposed in principle to doing this (except that it should be a
> sysfs parameter like all our other controls), but what's the reasoning
> behind needing it changed?

<vendor hat on>

Periodically turns up as a useful field sledgehammer for solving 
problems, until the real problem is found and fixed.  Got tired of a 
very similar patch manually bouncing around the "hey, pssst, this worked 
for me" backchannel IT network.

</red hat>

Can you be more specific about sysfs location?  A runtime-writable (via 
sysfs!) module parameter for a module-wide default seemed appropriate.

	Jeff
