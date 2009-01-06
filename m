From: Tony Battersby <tonyb@cybernetics.com>
Subject: Re: [PATCH] sym53c8xx_2: slave_alloc/destroy safety (2.6.27.5)
Date: Tue, 06 Jan 2009 11:26:07 -0500
Message-ID: <4963861F.5090404@cybernetics.com>
References: <49593940.9060102@cybernetics.com>	 <1230631843-16470-1-git-send-email-Aaro.Koskinen@nokia.com> <1230664572.18627.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([98.174.209.230]:3576 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbZAFQ0K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2009 11:26:10 -0500
In-Reply-To: <1230664572.18627.2.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Aaro Koskinen <Aaro.Koskinen@nokia.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

James Bottomley wrote:
> On Tue, 2008-12-30 at 12:10 +0200, Aaro Koskinen wrote:
>   
>> Thanks. The updated patch is below.
>>     
>
> Tony,
>
> Since we're lacking an active maintainer on this one and you seem
> interested, could you run these patches through your tests to make sure
> they're reasonably OK and then respond with an ack?
>
> Thanks,
>
> James
>
>
>
>   
This patch survived an overnight testing of "modprobe sym53c8xx;
modprobe -r sym53c8xx" in a loop, using a SCSI cable of marginal quality
that sometimes fails DV, with a mix of single-lun and multi-lun devices
of various SCSI revision levels, with many kernel debug options
enabled.  The only kernel warning message I see is the pre-existing and
already-reported problem about dma_free_coherent() being called with
interrupts disabled during rmmod, but that is not caused by this patch.

>From the description of this patch, I assume that it is a cleanup
instead of a fix for an actual problem.  Correspondingly, I don't have a
specific testcase that is improved by this patch.  I also have not
analyzed the source to see what the patch is trying to do.  However, the
current form of the patch passes testing as described above.

I will reply to the other patches in separate messages later.

Tested-by: Tony Battersby <tonyb@cybernetics.com>

Tony

