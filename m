From: Nix <nix@esperi.org.uk>
Subject: Re: [SCSI REGRESSION] 3.10.2 or 3.10.3: arcmsr failure at bootup / early userspace transition
Date: Mon, 29 Jul 2013 16:01:49 +0100
Message-ID: <8738qxfm02.fsf@spindle.srvr.nix>
References: <87r4ehfzhf.fsf@spindle.srvr.nix> <51F667C2.4020801@fastmail.fm>
	<87mwp5frdl.fsf@spindle.srvr.nix> <51F67959.2060803@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <51F67959.2060803@fastmail.fm> (Bernd Schubert's message of "Mon,
	29 Jul 2013 16:16:57 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, nick.cheng@areca.com.tw
List-Id: linux-scsi@vger.kernel.org

On 29 Jul 2013, Bernd Schubert spake thusly:

> On 07/29/2013 03:05 PM, Nix wrote:
>> On 29 Jul 2013, Bernd Schubert said:
>>> I tested this patch with ARC-1260 and F/W V1.49, no issues. Also, this
>>> patch is only in 3.10.3, but not yet in 3.10.1.
>>
>> ... and I see this problem with 3.10.3 but not 3.10.1. (Haven't tried
>> 3.10.2.)
>
> Hmm, indeed that points to this commit. I just don't see what could fail there.
>
> Could you try to run these commands with 3.10.1?
>
> # # check if reporting opcodes works
> # sg_opcodes -v  -n /dev/sdX
>
> # check ata information page
> # sg_vpd --page=0x89 /dev/sdX

If this might cause the same problem I think I'd better wait until work
is done for the day and the machine is no longer loaded, and can be
rebooted without harm...

>> No changes to arcmsr between those versions... I suspect I'll have to
>> bisect, which will be a complete pig because every failure means a hard
>> powerdown of this box. Always-on servers rarely appreciate hard
>> powerdowns :(
>>
>
> Maybe just revert this commit? Helpful would be some scsi logging to
> see which command actually fails. I guess you don't have a serial
> console?

Not at that stage, no! And, yes, a test revert of this one commit will
be the first thing I try this evening / tomorrow morning (depending on
system load).

-- 
NULL && (void)
