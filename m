From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Subject: Re: linux-next: Tree for July 27
Date: Tue, 27 Jul 2010 12:54:22 +0530
Message-ID: <AANLkTi=ki084ymBzsnbgnFw952BSnSDzUyL+YH-4353b@mail.gmail.com>
References: <20100727160708.722c39c1.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20100727160708.722c39c1.sfr@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Avi Kivity <avi@redhat.com>, Linux SCSI List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello Stephen,

On Tue, Jul 27, 2010 at 11:37 AM, Stephen Rothwell <sfr@canb.auug.org.a=
u> wrote:
> Hi all,
>
> Changes since 20100726:
>
> The arm tree lost its conflict.
>
> The microblaze tree lost its conflict.
>
> The mips tree gained a build failure so I used the version from
> next-20100726.
>
> The xfs tree still has its build failure so I used the version from
> next-20100723.
>
> The ieee2394 tree gained a build failure so I used the version from
> next-20100726.
>
> The kvm tree still has its build failure.
>
> The async_tx tree gained a conflict against the arm tree.
>
> The devicetree tree lost its conflict, but gained another against the
> microblaze tree.
>
> The xen tree lost its build problems but gained a conflict against Li=
nus'
> tree.
>
> The tip tree gained a conflict against the cpufreq tree.
>
> The tty tree gained a conflict against the genesis tree and a build
> failure for which I reverted 4 patches.
>
> The usb tree lost its conflicts.
>
> ---------------------------------------------------------------------=
-------
>
> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> (patches at http://www.kernel.org/pub/linux/kernel/v2.6/next/ ). =A0I=
f you
> are tracking the linux-next tree using git, you should not use "git p=
ull"
> to do so as that will try to merge the new linux-next release with th=
e
> old one. =A0You should use "git fetch" as mentioned in the FAQ on the=
 wiki
> (see below).
>
> You can see which trees have been included by looking in the Next/Tre=
es
> file in the source. =A0There are also quilt-import.log and merge.log =
files
> in the Next directory. =A0Between each merge, the tree was built with
> a ppc64_defconfig for powerpc and an allmodconfig for x86_64. After t=
he
> final fixups (if any), it is also built with powerpc allnoconfig (32 =
and
> 64 bit), ppc44x_defconfig and allyesconfig (minus
> CONFIG_PROFILE_ALL_BRANCHES - this fails its final link) and i386, sp=
arc
> and sparc64 defconfig. These builds also have
> CONFIG_ENABLE_WARN_DEPRECATED, CONFIG_ENABLE_MUST_CHECK and
> CONFIG_DEBUG_INFO disabled when necessary.
>
> Below is a summary of the state of the merge.
>
> We are up to 167 trees (counting Linus' and 22 trees of patches pendi=
ng
> for Linus' tree), more are welcome (even if they are currently empty)=
=2E
> Thanks to those who have contributed, and to those who haven't, pleas=
e do.
>
> Status of my local build tests will be at
> http://kisskb.ellerman.id.au/linux-next . =A0If maintainers want to g=
ive
> advice about cross compilers/configs that work, we are always open to=
 add
> more builds.
>
> Thanks to Jan Dittmer for adding the linux-next tree to his build tes=
ts
> at http://l4x.org/k/ , the guys at http://test.kernel.org/ and Randy
> Dunlap for doing many randconfig builds.
>
> There is a wiki covering stuff to do with linux-next at
> http://linux.f-seidel.de/linux-next/pmwiki/ . =A0Thanks to Frank Seid=
el.
>

I am getting following compilation warnings in linux-next 20100727:

  CC [M]  arch/x86/kvm/mmu.o
arch/x86/kvm/mmu.c: In function =91kvm_mmu_pte_write=92:
arch/x86/kvm/mmu.c:2908: warning: suggest parentheses around operand
of =91!=92 or change =91&=92 to =91&&=92 or =91!=92 to =91~=92

 CC      lib/decompress_bunzip2.o
lib/decompress_bunzip2.c: In function =91get_next_block=92:
lib/decompress_bunzip2.c:511: warning: the frame size of 1968 bytes is
larger than 1024 bytes

  CC      drivers/scsi/constants.o
drivers/scsi/constants.c: In function =91scsi_print_sense=92:
drivers/scsi/constants.c:1407: warning: zero-length gnu_printf format s=
tring
drivers/scsi/constants.c:1413: warning: zero-length gnu_printf format s=
tring
drivers/scsi/constants.c: In function =91scsi_print_result=92:
drivers/scsi/constants.c:1456: warning: zero-length gnu_printf format s=
tring


  CC      drivers/scsi/sd.o
drivers/scsi/sd.c: In function =91sd_print_sense_hdr=92:
drivers/scsi/sd.c:2617: warning: zero-length gnu_printf format string
drivers/scsi/sd.c:2619: warning: zero-length gnu_printf format string
drivers/scsi/sd.c: In function =91sd_print_result=92:
drivers/scsi/sd.c:2625: warning: zero-length gnu_printf format string

Thanks,
--
Jaswinder Singh.
