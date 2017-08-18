From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Re: [Regression 4.13-rc1] Resume does not work on Lenovo X60t
Date: Fri, 18 Aug 2017 16:45:18 +0200
Message-ID: <9123f447-c06b-6a67-b380-90338eb2dde8@molgen.mpg.de>
References: <7032513a-7a28-5807-40d4-cb0f7005d513@molgen.mpg.de>
 <20170805093014.GA6511@infradead.org>
 <d30803d1861c9c105a35845759f58f8d@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3.molgen.mpg.de ([141.14.17.11]:51378 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750881AbdHROpV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Aug 2017 10:45:21 -0400
In-Reply-To: <d30803d1861c9c105a35845759f58f8d@molgen.mpg.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Dear Christoph,


On 08/06/17 20:06, Paul Menzel wrote:

> On 2017-08-05 11:30, Christoph Hellwig wrote:
>> On Thu, Aug 03, 2017 at 07:42:15PM +0200, Paul Menzel wrote:
> 
>>> Since the merge windows opened for Linux 4.13, I am unable to resume 
>>> from ACPI S3 suspend on a Lenovo X60t. The graphics comes back, but I am 
>>> unable to enter anything, and the system seems to be hung. Magic SysRq keys 
>>> still work though, but powering the system of doesn’t work. The power 
>>> button also does not work.
>>>
>>> Please find the stack trace with Linux 4.13-rc3 captured over the serial
>>> console below.
>>
>> Is this really -rc3?  rc3 has a commit to disable block runtime pm
>> for blk-mq, which is now the default for scsi.  So with -rc1 we've
>> seen similar reports, but rc3 would be odd and suggest we have further
>> problems.
> 
> Yes, this was 4.13-rc3. Rebuilding the Linux kernel from commit 0fdd951c 
> (Merge tag 'media/v4.13-2' of 
> git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media) shows 
> the same behavior.

Just an update, that this is still present in Linux 4.13-rc5+, that 
means commit 04d49f3638d0 (Merge tag 'drm-fixes-for-v4.13-rc6' of 
git://people.freedesktop.org/~airlied/linux).


Kind regards,

Paul
