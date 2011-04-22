From: "werner" <w.landgraf@ru.ru>
Subject: Re: 2.6.39-rc3-git3 problem etc , reset-resistent problem
Date: Fri, 22 Apr 2011 16:44:09 -0400
Message-ID: <web-511195706@zbackend1.aha.ru>
References: <web-506519881@zbackend1.aha.ru>
 <20110422183525.GE21902@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zfrontend1.aha.ru ([195.2.83.147]:58450 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751984Ab1DVUoP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Apr 2011 16:44:15 -0400
In-Reply-To: <20110422183525.GE21902@mtj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, axboe@kernel.dk, James.Bottomley@HansenPartnership.com, mingo@elte.hu, Andrew Morton <akpm@linux-foundation.org>, gregkh@suse.de, randy.dunlap@oracle.coml

With reboot-resistent  i mean, that this is a problem 
which, after the 1st crash, something is changed on the 
system so that also on subsequent reboots it crashs 
quickly, and this change don't go away.    Only if it is 
explicitely deleted.   This can be, for example, by 
changes of temporary files which are corrupted and stay 
corrupted and like this after reboot are used, or if there 
stay resident parts in the memory (perhaps by the battery 
current).

This problem is seldom, but right now it's happening, with 
a serie of the reported errors.

This problem continues also on 2.6.39-rc4-git4.


The computer crashs, tipically 1 min. (at 2.6.39-rc1) or 
later, 20 -60 min. after the boot.  This happens mainly, 
if you bunzip2 or copy a big file.   I think this have 
something to do with the memory administration, perhaps 
with paging.

When you reboot after such a 1st crash, then the computer 
crashs quickly at the beginning of the boot process, when 
it's init ata1.0.0.  From this, my most fotos are. It 
looks, that the computer try to assign anything to ata1. 
  What, that's changing often. Sometimes it's the grafic 
card, if before the crash I was in grafic mode.

If you then reboot again, even 10 times, then the same 
happens.  It crashs again at the ata1 stage, or short 
after.  Even if I use the reboot button, or switch off the 
computer completely.   Thus, something is changed by the 
1st crash, and stays changed even after re-booting or 
power-off.

This stops only, if I wait 5 minutes or more (what 
suggests that the 1st crash let something memory-resident 
what causes the next crashs).   Or, if I boot with a 
stable kernel (2.6.38.3) which don't crash.      Then, 
2.6.39-rcX don't crash again at the ata1 stage, but later 
just like the 1st time (currently, if I unzip or copy a 
big file), however after this, subsequently it crashs 
again at the ata1 state, i.e. the same problem repeats.

I have no other tools, the only what I can do is, to make 
screen fotos.

Also, I imediately compile all new -git's  .  Thus, it's 
difficult to go back, to reproduce / repeat an error.  But 
I'll try to make more fotos.

BUT THE KERNEL PEOPLE FINALLY SHOULD INCLUDE, THAT DMESG 
AT EACH BOOT GET ANOTHER SUFFIX, OR THE OLD DMESG GET A 
COPY dmesg.old, SO THAT AFTER A CRASH ONE CAN READ DMESG 
WITHOUT IT WAS OVERWROTEN !!!!!!

In a separate mail, I'll send two more screen shots of 
crashs.

W.Landgraf





===============================================================
On Fri, 22 Apr 2011 20:35:25 +0200
  Tejun Heo <tj@kernel.org> wrote:
> Hello, werner.
> 
> On Sun, Apr 17, 2011 at 02:38:58AM -0400, werner wrote:
>> Enclosed pls find a screen foto of another crash with 
>>this
>> reset-resistent problem.
> 
> What do you mean by reset-resistant?
> 
>> As said, after patching blk and scsi in 2.6.39-rc3-git4 
>>as someone
>> suggested me to try out, happened crashs short  or 
>>longer time after
>> booting, which caused a rather early crash during 
>>subsequent boots,
>> which don't go away  even after re-set or power-off, and 
>>occurs
>> again and again with 2.6.39-rcX  .  This goes away only 
>>if I boot
>> with 2.6.38.2 or .3 ; in this case, if after this I boot 
>>again with
>> 2.6.39-rc3-git4+patches, then repeats the same, i.e. the 
>>first time
>> it crashs only after the end of booting, but 
>>subsequently again in
>> the early stage.
>> 
>> I think this is a khugepaged problem, or that the 
>>computer wrongly
>> interpretes the video card or anything else as an scsi 
>>or blk
>> device.  At least subjectively, the sticking after 
>>booting is very
>> similar to the khugepaged problem which I reclaimed 
>>during
>> 2.6.38-rc1 (or was it .37-rc1 ), and which then was 
>>corrected, but
>> perhaps it wasn't corrected really and now comes back.
> 
> Unfortunately, I can't really make much sense of your 
>report and the
> screenshot seems already deep into multiple failures 
>making it very
> difficult to tell what initiated the whole situation. 
> As Jens
> requested before, can you please setup serial or 
>netconsole and try to
> capture the full kernel log from boot to crash?
> 
> Thank you.
> 
> -- 
> tejun
> 
> 

"werner" <w.landgraf@ru.ru>
---
Professional hosting for everyone - http://www.host.ru
