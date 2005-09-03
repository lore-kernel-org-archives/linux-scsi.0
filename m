From: Peter Williams <pwil3058@bigpond.net.au>
Subject: Re: 2.6.13-mm1: hangs during boot ...
Date: Sun, 04 Sep 2005 08:48:52 +1000
Message-ID: <431A2854.2000604@bigpond.net.au>
References: <F7DC2337C7631D4386A2DF6E8FB22B30047FA090@hdsmsx401.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751281AbVICWs7@vger.kernel.org>
In-Reply-To: <F7DC2337C7631D4386A2DF6E8FB22B30047FA090@hdsmsx401.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Brown, Len" <len.brown@intel.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Brown, Len wrote:
>>>>Please then try the latest ACPI patch here:
>>>
>>> > 
>>
>>http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches
>>/release/2.6.13/acpi-20050902-2.6.13.diff.gz
>>
>>> > It should apply to vanilla 2.6.13 with a reject in ia64/Kconfig
>>> > that you can ignore.
>>> > 
>>> > If this works, then we munged git-acpi.patch in 
>>
>>2.6.13-mm1 somehow.
>>
>>> There were no problems with this patch applied.  So it 
>>
>>looks like the 
>>
>>> munge theory is correct.
>>
>>That diff is significantly different from the diff I plucked from
>>master.kernel.org:/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6
>>.git#test
>>for 2.6.13-mm1.
>>
>>Doing (patch -R | grep FAILED) on 2.6.13-mm1 says:
> 
> 
> Right.
> 2.6.13/acpi-20050902-2.6.13.diff.gz
> is newers than 2.6.13-rc1's git-acpi.patch
> 
> 2.6.13/acpi-20050815-2.6.13.diff.gz
> is a closer match -- though not exact.
> 
> Peter, it might be illustrative if you have a moment
> if you can also test 2.6.13/acpi-20050815-2.6.13.diff.gz
> all by itself.
> 
> If it fails,

It does.

> then I broke -mm1
> with acpi-20050815-2.6.13.diff.gz, but fixed
> it by acpi-20050902-2.6.13.diff.gz.

So you did.

> 
> If it succeeds, then the issue lies in the relatively small delta
> between acpi-20050815-2.6.13.diff.gz 2.6.13-mm1's git-acpi.patch.
> 
> thanks,
> -Len
> 

My pleasure
Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
