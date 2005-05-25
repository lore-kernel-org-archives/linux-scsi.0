From: Mogens Valentin <monz@danbbs.dk>
Subject: Re: [ANNOUNCE] sdparm 0.92
Date: Wed, 25 May 2005 20:07:02 +0200
Message-ID: <4294BEC6.30005@danbbs.dk>
References: <428DC633.5050403@torque.net> <4293BD80.1050503@danbbs.dk> <4293D798.4020606@torque.net> <4293E62A.5080408@danbbs.dk> <429466EC.3080801@torque.net> <429478C2.3000003@danbbs.dk> <429480F9.6050802@torque.net> <42949D2E.5020309@danbbs.dk>
Reply-To: monz@danbbs.dk
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pfepa.post.tele.dk ([195.41.46.235]:39792 "EHLO
	pfepa.post.tele.dk") by vger.kernel.org with ESMTP id S261500AbVEYSGT
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 May 2005 14:06:19 -0400
In-Reply-To: <42949D2E.5020309@danbbs.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Mogens Valentin wrote:
> Douglas Gilbert wrote:
> 
>> Mogens Valentin wrote:
>>
>>> Douglas Gilbert wrote:
>>>
>>>> Mogens Valentin wrote:
>>>>
>>>>> Douglas Gilbert wrote:
>>>>>
>>>>>> With sg_start (in the sg3_utils package) I have tried
>>>>>> to spin up and down an ATA disk inside a USB enclosure
>>>>>> without success. The same command on a USB connected
>>>>>> CD/DVD combo drive did work.
>>>>>>
>>>>>> Could you try sg_start on your USB external enclosure
>>>>>> which I assume contains an ATA disk rather than a
>>>>>> SCSI (SPI) disk and report if it works?
>>>>>
>>>>> Sure. Got it, compiled, but got the error:
>>>>>   .../usr/include/scsi/sg.h /usr/include/scsi/scsi.h
>>>>>   /usr/include/stdint.h   sg_lib.h sg_cmds.h llseek.h
>>>>>   gcc: cannot specify -o with -c or -S and multiple compilations
>>>>>   make: *** [sgp_dd.o] Error 1
>>>>>
>>>>> I could only find  -o  and  -c  in the makefiles around line 95.
>>>>>
>>>>> Slack 9.1 / 2.6.10 from sources.
>>>>
>>>> Could you try the sg3_utils-1.15.tgz beta at the
>>>> top of http://www.torque.net/sg [in the news section].
>>>> Hopefully that cures the compile problem.
>>>
>>> Nope, but it changes the error. You changed the makefile exactly as I 
>>> tried it, removing '-c' in line 95.
>>> This results in missing header files compiles:
> 
>>> ...
>>> creating sg_dd
>>> gcc  -g -O2 -Wall -W -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 
>>> -D_REENTRANT -c sgp_dd.c ...
>>> .../usr/include/stdint.h sg_lib.h sg_cmds.h llseek.h
>>> gcc: compilation of header file requested
>>> gcc: compilation of header file requested
>>> ...
>>> make: *** [sgp_dd.o] Error 1
>>>
>>>
>>> Forgot to mention I have gcc version 3.2.3, FWIW..
>>> It's not exactly an uncommon problem; I googled a bit :p
>>> I haven't pinpointed the problem as yet, but found comments (from 
>>> compiling other apps) that it could be either a gcc versioning 
>>> problem, a problem with -I or -D switches, or simply a Makefile problem.

Dear oh dear!  Forgot to tell you I did:
   make clean; make dep; make

Doing just  make clean; make  did the job. Sorry about the problems.
Still,  make dep  ought to work :p

Doesn't change the fact that either my Prolific interface or the disk 
doesn't support the needed scsi modes..

-- 
Kind regards,
Mogens Valentin

