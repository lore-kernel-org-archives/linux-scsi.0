From: Matthias Brugger <matthias.bgg@gmail.com>
Subject: Re: [PATCH RFC 00/15] Zero ****s, hugload of hugs <3
Date: Fri, 30 Nov 2018 21:31:13 +0100
Message-ID: <f9c2db3b-2c9a-5e8c-e899-59bb5f554d19@gmail.com>
References: <20181130192737.15053-1-jarkko.sakkinen@linux.intel.com>
 <CAGXu5j+jBNBsD3pvUSfEh6Lc5T1YMpbM0HeG1c6BHiJe+cKVOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAGXu5j+jBNBsD3pvUSfEh6Lc5T1YMpbM0HeG1c6BHiJe+cKVOQ@mail.gmail.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Daniel Axtens <dja@axtens.net>, "David S. Miller" <davem@davemloft.net>, Dominik Brodowski <linux@dominikbrodowski.net>, Maling list - DRI developers <dri-devel@lists.freedesktop.org>, Eric Dumazet <edumazet@google.com>, federico.vaga@vaga.pv.it, Geert Uytterhoeven <geert+renesas@glider.be>, Helge Deller <deller@gmx.de>, Jonathan Corbet <corbet@lwn.net>, Joshua Kinard <kumba@gentoo.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-m68k@lists.linux-m68k.org
List-Id: linux-scsi@vger.kernel.org



On 30/11/2018 20:40, Kees Cook wrote:
> On Fri, Nov 30, 2018 at 11:27 AM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
>>
>> In order to comply with the CoC, replace **** with a hug.
> 
> Heh. I support the replacement of the stronger language, but I find
> "hug", "hugged", and "hugging" to be very weird replacements. Can we
> bikeshed this to "heck", "hecked", and "hecking" (or "heckin" to
> follow true Doggo meme style).
> 
> "This API is hugged" doesn't make any sense to me. "This API is
> hecked" is better, or at least funnier (to me). "Hug this interface"
> similarly makes no sense, but "Heck this interface" seems better.
> "Don't touch my hecking code", "What the heck were they thinking?"
> etc... "hug" is odd.
> 

Like John I don't think that the word "fuck" is something we have to ban from
the source code, but I don't care too much. Anyway, please don't change it to
something like heck as it might be difficult for non-english speaker to understand.

Regards,
Matthias

> Better yet, since it's only 17 files, how about doing context-specific
> changes? "This API is terrible", "Hateful interface", "Don't touch my
> freakin' code", "What in the world were they thinking?" etc?
> 
> -Kees
> 
>>
>> Jarkko Sakkinen (15):
>>   MIPS: replace **** with a hug
>>   Documentation: replace **** with a hug
>>   drm/nouveau: replace **** with a hug
>>   m68k: replace **** with a hug
>>   parisc: replace **** with a hug
>>   cpufreq: replace **** with a hug
>>   ide: replace **** with a hug
>>   media: replace **** with a hug
>>   mtd: replace **** with a hug
>>   net/sunhme: replace **** with a hug
>>   scsi: replace **** with a hug
>>   inotify: replace **** with a hug
>>   irq: replace **** with a hug
>>   lib: replace **** with a hug
>>   net: replace **** with a hug
>>
>>  Documentation/kernel-hacking/locking.rst      |  2 +-
>>  arch/m68k/include/asm/sun3ints.h              |  2 +-
>>  arch/mips/pci/ops-bridge.c                    | 24 +++++++++----------
>>  arch/mips/sgi-ip22/ip22-setup.c               |  2 +-
>>  arch/parisc/kernel/sys_parisc.c               |  2 +-
>>  drivers/cpufreq/powernow-k7.c                 |  2 +-
>>  .../gpu/drm/nouveau/nvkm/subdev/bios/init.c   |  2 +-
>>  .../nouveau/nvkm/subdev/pmu/fuc/macros.fuc    |  2 +-
>>  drivers/ide/cmd640.c                          |  2 +-
>>  drivers/media/i2c/bt819.c                     |  8 ++++---
>>  drivers/mtd/mtd_blkdevs.c                     |  2 +-
>>  drivers/net/ethernet/sun/sunhme.c             |  4 ++--
>>  drivers/scsi/qlogicpti.h                      |  2 +-
>>  fs/notify/inotify/inotify_user.c              |  2 +-
>>  kernel/irq/timings.c                          |  2 +-
>>  lib/vsprintf.c                                |  2 +-
>>  net/core/skbuff.c                             |  2 +-
>>  17 files changed, 33 insertions(+), 31 deletions(-)
>>
>> --
>> 2.19.1
>>
> 
> 
