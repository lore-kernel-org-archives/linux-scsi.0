From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: linux-next: Tree for Jun 6 (scsi_debug.c)
Date: Fri, 2 Sep 2016 08:40:47 -0700
Message-ID: <dfed0e24-0ea1-d364-9a6a-d07e3d55d178@infradead.org>
References: <20160606142058.44b82e38@canb.auug.org.au>
 <57563B40.4090801@infradead.org>
 <CALLJCT0r7FfL=rLARTV9-YB-x10d1w0hYMOO6BC-dv8zGC4VLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALLJCT0r7FfL=rLARTV9-YB-x10d1w0hYMOO6BC-dv8zGC4VLA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Masanari Iida <standby24x7@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next <linux-next@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 08/23/16 16:22, Masanari Iida wrote:
> This one still exist on linus's tree (as of  v4.8-rc3).
> 
> CALL    scripts/checksyscalls.sh
>   CHK     kernel/config_data.h
>   Building modules, stage 2.
>   MODPOST 720 modules
> ERROR: "ip_compute_csum" [drivers/scsi/scsi_debug.ko] undefined!
> scripts/Makefile.modpost:91: recipe for target '__modpost' failed
> make[1]: *** [__modpost] Error 1
> Makefile:1178: recipe for target 'modules' failed
> make: *** [modules] Error 2
> 
> Masanari

Hi,

Do you have the kernel .config file that causes this?
I can no longer reproduce it.

What $arch did you build on?

Thanks.

> On Tue, Jun 7, 2016 at 12:10 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
>> On 06/05/16 21:20, Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Changes since 20160603:
>>
>> on x86_64:
>>
>> ERROR: "ip_compute_csum" [drivers/scsi/scsi_debug.ko] undefined!
>>
>> CONFIG_GENERIC_CSUM doesn't seem to exist for x86, so lib/checksum.o is not built.
>>
>>
>> --
>> ~Randy


-- 
~Randy
