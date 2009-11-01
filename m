From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] Add missing #include for include/scsi/osd_protocol.h
Date: Sun, 01 Nov 2009 15:11:48 +0200
Message-ID: <4AED8914.3080700@panasas.com>
References: <20091031093337.GA3339@deprecation.cyrius.com>	<4AED5FBF.6020308@panasas.com>	<20091101105416.GN20819@deprecation.cyrius.com>	<4AED7037.1080509@panasas.com> <20091101225256.3aa2797e.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dip-colo-pa.panasas.com ([67.152.220.67]:29597 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751763AbZKANLq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Nov 2009 08:11:46 -0500
In-Reply-To: <20091101225256.3aa2797e.sfr@canb.auug.org.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Martin Michlmayr <tbm@cyrius.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Randy Dunlap <randy.dunlap@oracle.com>

On 11/01/2009 01:52 PM, Stephen Rothwell wrote:
> Hi Boaz,
> 
> On Sun, 01 Nov 2009 13:25:43 +0200 Boaz Harrosh <bharrosh@panasas.com> wrote:
>>
>> Yes I can see now linux/unaligned/le_byteshift.h and linux/unaligned/be_byteshift.h look
>> broken, they do not include headers who's definitions are used. All the other alternatives
>> in linux/unaligned/ ,example access_ok.h, do. Sigh
>>
>> But one thing I do not understand, in linux-next is there not a single ARM platform that
>> does a "make allmodconfig". (Or they do but the compilation error was never reported?)
> 
> The arm allmodconfig is really a non starter I am told (allmodconfig is
> really per arch, not per platform).  However you can see all the
> linux-next build results for arm (and lots of others) at
> http://kisskb.ellerman.id.au/kisskb/branch/9/ .  I often don't have time
> to review the build results - I assume that other people with an interest
> will do so.
> 

>From the list you've sent (above), there is not a single ARM platform
that does an allXXXconfig. They are all a "defconfig". I'll bear that
in mind next time.

(Time for that arm cross compiler)

Thanks
Boaz
