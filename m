From: Jeff Garzik <jeff@garzik.org>
Subject: Re: Full hostlock pushdown available
Date: Tue, 02 Nov 2010 11:59:52 -0400
Message-ID: <4CD03578.3050801@garzik.org>
References: <20101028150508.GA2385@basil.fritz.box> <4CCD5F7F.8020808@panasas.com> <tkrat.c4793af298337eff@s5r6.in-berlin.de> <4CCE271D.7040400@garzik.org> <20101101135338.GA25817@basil.fritz.box> <4CCEE33F.5030300@garzik.org> <20101101175742.GG25817@basil.fritz.box> <4CCF0DFE.4050106@garzik.org> <20101102092111.GK25817@basil.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20101102092111.GK25817@basil.fritz.box>
Sender: linux-ide-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Boaz Harrosh <bharrosh@panasas.com>, James.Bottomley@suse.de, nab@linux-iscsi.org, linux-scsi@vger.kernel.org, Linux IDE mailing list <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 11/02/2010 05:21 AM, Andi Kleen wrote:
>> IOW, it's doing the exact opposite of what the previous code did
>> (release the scsi host lock, before acquiring the ATA port/host
>> spinlock), not at all an equivalent transformation.
>>
>> The following sequence would seem to better preserve the existing
>> lock profile, correct?
>
> Possibly, but it's not a mechanic change.

Oh come on.  Anybody can run a script.  It's not a mechanical change if 
you failed to create an equivalent transformation, fail to maintain 
existing lock order, _inverting_ the existing locking.

Have you done any analysis on the correctness of this new locking?


> The goal here is not really what comes out of this patch,
> but dropping the host lock completely. This is just the first step.

That doesn't excuse lack of analysis or correctness.

Boaz' approach is OBVIOUSLY mechanical, correct and bisectable.  Yours 
is not.

	Jeff



