From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Cbe-oss-dev] LIO Target iSCSI/SE PS3-Linux / FC8 builds
Date: Mon, 04 Feb 2008 07:52:40 -0800
Message-ID: <1202140360.11265.543.camel@haakon2.linux-iscsi.org>
References: <1202134623.11265.524.camel@haakon2.linux-iscsi.org>
	 <200802041647.06234.marc.dietrich@ap.physik.uni-giessen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755876AbYBDPx2@vger.kernel.org>
In-Reply-To: <200802041647.06234.marc.dietrich@ap.physik.uni-giessen.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>
Cc: cbe-oss-dev@ozlabs.org, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Open iSCSI <open-iscsi@googlegroups.com>
List-Id: linux-scsi@vger.kernel.org

Hi Marc,

You can generate the kernel RPM with 'make kernel ARCH=3Dpowerpc'.

Also, while module-assistant is supported on debian/ubuntu,
trunk/buildtools/ currently does not support generating kernel module
source rpms.  If you want to send a patch, I would be more than happy t=
o
take it.

--nab


On Mon, 2008-02-04 at 16:47 +0100, Marc Dietrich wrote:
> Hi Nicholas,
>=20
> can you please also upload a src.rpm? I'm having toubles compiling th=
e kernel=20
> code:
>=20
> # cd target/ ; ./autoconfig --write-to-file ; cat .make_autoconfig ; =
make=20
> kernel
> /usr/src/linux-iscsi/trunk/target/.make_autoconfig
> ARCH?=3Dppc
> AUTO_CFLAGS?=3D -DHAS_UTS_RELEASE -DUSE_SCSI_H -I/lib/modules/2.6.24-=
06289-g144de36/source/drivers/scsi  -DUSE_MSLEEP -DUSE_COMPAT_IOCTL -Ds=
csi_execute_async_address  -DPYX_ISCSI_VENDOR=3D'"Linux-iSCSI.org"'  -D=
IQN_PREFIX=3D'"iqn.2003-01.org.linux-iscsi"'  -DLINUX -DLINUX_SCATTERLI=
ST_HAS_PAGE -DSVN_VSN=3D\"209\"
> BASENAME?=3DFedoraCore-R8-Werewolf.ppc
> DISTRO?=3DFEDORA
> KERNEL?=3D26
> KERNEL_DIR?=3D/lib/modules/2.6.24-06289-g144de36/build
> KERNEL_INCLUDE_DIR?=3D/lib/modules/2.6.24-06289-g144de36/source/inclu=
de
> KERNEL_SOURCE_DIR?=3D/lib/modules/2.6.24-06289-g144de36/source
> KERNEL_VERSION_INFO?=3DLINUX_KERNEL_26
> OSTYPE?=3DLINUX
> PYX_ISCSI_VERSION?=3D2.9.0.209
> RELEASE?=3D2.6.24-06289-g144de36
> RELEASES?=3DARRAY(0x102052d4)
> RPM_DIR?=3D/usr/src/redhat
> SNMP?=3D0
> SYSTEM?=3DFedoraCore-R8-Werewolf
> VERSION_IPYXD?=3D2.9.0.209
> make -C target clean all
> make[1]: Entering directory `/usr/src/linux-iscsi/trunk/target/target=
'
> rm -f /usr/src/linux-iscsi/trunk/target/target/../common/iscsi_crc.o =
/usr/src/linux-iscsi/trunk/target/target/../common/iscsi_debug_opcodes.=
o /usr/src/linux-iscsi/trunk/target/target/../common/iscsi_parameters.o=
 /usr/src/linux-iscsi/trunk/target/target/../common/iscsi_seq_and_pdu_l=
ist.o /usr/src/linux-iscsi/trunk/target/target/../common/iscsi_serial.o=
 /usr/src/linux-iscsi/trunk/target/target/../common/iscsi_thread_queue.=
o /usr/src/linux-iscsi/trunk/target/target/iscsi_target_datain_values.o=
 /usr/src/linux-iscsi/trunk/target/target/iscsi_target_device.o /usr/sr=
c/linux-iscsi/trunk/target/target/iscsi_target_discovery.o /usr/src/lin=
ux-iscsi/trunk/target/target/iscsi_target_erl0.o /usr/src/linux-iscsi/t=
runk/target/target/iscsi_target_erl1.o /usr/src/linux-iscsi/trunk/targe=
t/target/iscsi_target_erl2.o /usr/src/linux-iscsi/trunk/target/target/i=
scsi_target_feature_obj.o /usr/src/linux-iscsi/trunk/target/target/iscs=
i_target_hba.o /usr/src/linux-iscsi/trunk/target/target/iscsi_target_in=
fo.o /usr/src/linux-iscsi/trunk/target/target/iscsi_target_ioctl.o /usr=
/src/linux-iscsi/trunk/target/target/iscsi_target_linux_proc.o /usr/src=
/linux-iscsi/trunk/target/target/iscsi_target_login.o /usr/src/linux-is=
csi/trunk/target/target/iscsi_target_nego.o /usr/src/linux-iscsi/trunk/=
target/target/iscsi_target_nodeattrib.o /usr/src/linux-iscsi/trunk/targ=
et/target/iscsi_target_plugin.o /usr/src/linux-iscsi/trunk/target/targe=
t/iscsi_target_reportluns.o /usr/src/linux-iscsi/trunk/target/target/is=
csi_target_scdb.o /usr/src/linux-iscsi/trunk/target/target/iscsi_target=
_seobj.o /usr/src/linux-iscsi/trunk/target/target/iscsi_target_tmr.o /u=
sr/src/linux-iscsi/trunk/target/target/iscsi_target_tpg.o /usr/src/linu=
x-iscsi/trunk/target/target/iscsi_target_transport.o /usr/src/linux-isc=
si/trunk/target/target/iscsi_target_util.o /usr/src/linux-iscsi/trunk/t=
arget/target/iscsi_target.o /usr/src/linux-iscsi/trunk/target/target/di=
v64.o /usr/src/linux-iscsi/trunk/target/target/iscsi_target_raid.o /usr=
/src/linux-iscsi/trunk/target/target/iscsi_target_repl.o /usr/src/linux=
-iscsi/trunk/target/target/iscsi_target_iblock.o /usr/src/linux-iscsi/t=
runk/target/target/iscsi_target_pscsi.o /usr/src/linux-iscsi/trunk/targ=
et/target/iscsi_target_rd.o /usr/src/linux-iscsi/trunk/target/target/is=
csi_target_file.o /usr/src/linux-iscsi/trunk/target/target/iscsi_target=
_vt.o /usr/src/linux-iscsi/trunk/target/target/iscsi_target_mc.o /usr/s=
rc/linux-iscsi/trunk/target/target/iscsi_target_mib.o /usr/src/linux-is=
csi/trunk/target/target/iscsi_target_mod.o /usr/src/linux-iscsi/trunk/t=
arget/target/iscsi_target_mod.mod.o
> rm -f iscsi_target_mod.ko iscsi_target_mod.mod.c
> rm -f .*.cmd ../common/.*.cmd .make_autoconfig *~
> rm -fr .tmp_versions
> make -C /lib/modules/2.6.24-06289-g144de36/build=20
> SUBDIRS=3D/usr/src/linux-iscsi/trunk/target/target modules=20
> CWD=3D/usr/src/linux-iscsi/trunk/target/target ARCH=3Dppc KBUILD_VERB=
OSE=3D0
> make[2]: Entering directory `/usr/src/ps3-linux'
>   CC [M]  /usr/src/linux-iscsi/trunk/target/target/../common/iscsi_cr=
c.o
> In file included from include/asm/mmu.h:7,
>                  from include/asm/lppaca.h:32,
>                  from include/asm/paca.h:20,
>                  from include/asm/hw_irq.h:17,
>                  from include/asm/system.h:9,
>                  from include/linux/list.h:9,
>                  from include/linux/preempt.h:11,
>                  from include/linux/spinlock.h:49,
>                  from include/linux/mmzone.h:7,
>                  from include/linux/gfp.h:4,
>                  from include/linux/slab.h:14,
>                 =20
> from /usr/src/linux-iscsi/trunk/target/target/../common/iscsi_crc.c:2=
9:
> include/asm/mmu-hash64.h: In function =E2=80=98hpte_encode_v=E2=80=99=
:
> include/asm/mmu-hash64.h:213: warning: left shift count >=3D width of=
 type
> include/asm/mmu-hash64.h: In function =E2=80=98hpte_encode_r=E2=80=99=
:
> include/asm/mmu-hash64.h:228: warning: integer constant is too large=20
> for =E2=80=98unsigned long=E2=80=99 type
> include/asm/mmu-hash64.h: In function =E2=80=98hpt_va=E2=80=99:
> include/asm/mmu-hash64.h:245: warning: left shift count >=3D width of=
 type
> include/asm/mmu-hash64.h:245: warning: integer constant is too large=20
> for =E2=80=98unsigned long=E2=80=99 type
> include/asm/mmu-hash64.h: In function =E2=80=98hpt_hash=E2=80=99:
> include/asm/mmu-hash64.h:260: warning: right shift count >=3D width o=
f type
> include/asm/mmu-hash64.h:261: warning: integer constant is too large=20
> for =E2=80=98unsigned long=E2=80=99 type
> include/asm/mmu-hash64.h:263: warning: integer constant is too large=20
> for =E2=80=98unsigned long=E2=80=99 type
> include/asm/mmu-hash64.h: In function =E2=80=98get_kernel_vsid=E2=80=99=
:
> include/asm/mmu-hash64.h:440: error: =E2=80=98SID_SHIFT=E2=80=99 unde=
clared (first use in this=20
> function)
> include/asm/mmu-hash64.h:440: error: (Each undeclared identifier is r=
eported=20
> only once
> include/asm/mmu-hash64.h:440: error: for each function it appears in.=
)
> include/asm/mmu-hash64.h:440: warning: right shift count >=3D width o=
f type
> include/asm/mmu-hash64.h:440: warning: left shift count >=3D width of=
 type
> include/asm/mmu-hash64.h:440: warning: right shift count >=3D width o=
f type
> include/asm/mmu-hash64.h:440: warning: left shift count >=3D width of=
 type
> include/asm/mmu-hash64.h:441: error: =E2=80=98SID_SHIFT_1T=E2=80=99 u=
ndeclared (first use in=20
> this function)
> include/asm/mmu-hash64.h: In function =E2=80=98user_segment_size=E2=80=
=99:
> include/asm/mmu-hash64.h:448: error: =E2=80=98SID_SHIFT_1T=E2=80=99 u=
ndeclared (first use in=20
> this function)
> include/asm/mmu-hash64.h: In function =E2=80=98get_vsid=E2=80=99:
> include/asm/mmu-hash64.h:458: error: =E2=80=98SID_SHIFT=E2=80=99 unde=
clared (first use in this=20
> function)
> include/asm/mmu-hash64.h:458: warning: right shift count >=3D width o=
f type
> include/asm/mmu-hash64.h:458: warning: left shift count >=3D width of=
 type
> include/asm/mmu-hash64.h:458: warning: right shift count >=3D width o=
f type
> include/asm/mmu-hash64.h:458: warning: left shift count >=3D width of=
 type
> include/asm/mmu-hash64.h:460: error: =E2=80=98SID_SHIFT_1T=E2=80=99 u=
ndeclared (first use in=20
> this function)
> In file included from include/asm/spinlock.h:25,
>                  from include/linux/spinlock.h:87,
>                  from include/linux/mmzone.h:7,
>                  from include/linux/gfp.h:4,
>                  from include/linux/slab.h:14,
>                 =20
> from /usr/src/linux-iscsi/trunk/target/target/../common/iscsi_crc.c:2=
9:
> include/asm/iseries/hv_call.h: In function =E2=80=98HvCall_setVirtual=
Decr=E2=80=99:
> include/asm/iseries/hv_call.h:85: warning: integer constant is too la=
rge=20
> for =E2=80=98unsigned long=E2=80=99 type
> include/asm/iseries/hv_call.h: In function =E2=80=98HvCall_yieldProce=
ssor=E2=80=99:
> include/asm/iseries/hv_call.h:90: warning: integer constant is too la=
rge=20
> for =E2=80=98unsigned long=E2=80=99 type
> include/asm/iseries/hv_call.h: In function =E2=80=98HvCall_setEnabled=
Interrupts=E2=80=99:
> include/asm/iseries/hv_call.h:95: warning: integer constant is too la=
rge=20
> for =E2=80=98unsigned long=E2=80=99 type
> include/asm/iseries/hv_call.h: In=20
> function =E2=80=98HvCall_setLogBufferFormatAndCodepage=E2=80=99:
> include/asm/iseries/hv_call.h:101: warning: integer constant is too l=
arge=20
> for =E2=80=98unsigned long=E2=80=99 type
> include/asm/iseries/hv_call.h: In function =E2=80=98HvCall_sendIPI=E2=
=80=99:
> include/asm/iseries/hv_call.h:108: warning: integer constant is too l=
arge=20
> for =E2=80=98unsigned long=E2=80=99 type
> In file included from include/asm/pgtable.h:13,
>                  from include/linux/mm.h:39,
>                 =20
> from /usr/src/linux-iscsi/trunk/target/target/../include/iscsi_linux_=
defs.h:27,
>                 =20
> from /usr/src/linux-iscsi/trunk/target/target/../include/iscsi_crc.h:=
21,
>                 =20
> from /usr/src/linux-iscsi/trunk/target/target/../common/iscsi_crc.c:3=
5:
> include/asm/pgtable-ppc64.h:32:50: warning: "SID_SHIFT" is not define=
d
> include/asm/pgtable-ppc64.h:33:2: error: #error TASK_SIZE_USER64 exce=
eds user=20
> VSID range
> In file included from include/asm/pgtable.h:13,
>                  from include/linux/mm.h:39,
>                 =20
> from /usr/src/linux-iscsi/trunk/target/target/../include/iscsi_linux_=
defs.h:27,
>                 =20
> from /usr/src/linux-iscsi/trunk/target/target/../include/iscsi_crc.h:=
21,
>                 =20
> from /usr/src/linux-iscsi/trunk/target/target/../common/iscsi_crc.c:3=
5:
> include/asm/pgtable-ppc64.h: In function =E2=80=98find_linux_pte=E2=80=
=99:
> include/asm/pgtable-ppc64.h:429: warning: right shift count >=3D widt=
h of type
> In file included from include/asm/pgtable.h:40,
>                  from include/linux/mm.h:39,
>                 =20
> from /usr/src/linux-iscsi/trunk/target/target/../include/iscsi_linux_=
defs.h:27,
>                 =20
> from /usr/src/linux-iscsi/trunk/target/target/../include/iscsi_crc.h:=
21,
>                 =20
> from /usr/src/linux-iscsi/trunk/target/target/../common/iscsi_crc.c:3=
5:
> include/asm-generic/pgtable.h: In function =E2=80=98pud_none_or_clear=
_bad=E2=80=99:
> include/asm-generic/pgtable.h:181: warning: integer constant is too l=
arge=20
> for =E2=80=98unsigned long=E2=80=99 type
> include/asm-generic/pgtable.h:181: warning: comparison is always fals=
e due to=20
> limited range of data type
> include/asm-generic/pgtable.h: In function =E2=80=98pmd_none_or_clear=
_bad=E2=80=99:
> include/asm-generic/pgtable.h:192: warning: integer constant is too l=
arge=20
> for =E2=80=98unsigned long=E2=80=99 type
> include/asm-generic/pgtable.h:192: warning: comparison is always fals=
e due to=20
> limited range of data type
> In file included=20
> from /usr/src/linux-iscsi/trunk/target/target/../include/iscsi_linux_=
defs.h:27,
>                 =20
> from /usr/src/linux-iscsi/trunk/target/target/../include/iscsi_crc.h:=
21,
>                 =20
> from /usr/src/linux-iscsi/trunk/target/target/../common/iscsi_crc.c:3=
5:
> include/linux/mm.h: In function =E2=80=98virt_to_head_page=E2=80=99:
> include/linux/mm.h:255: warning: integer constant is too large for =E2=
=80=98unsigned=20
> long=E2=80=99 type
> include/linux/mm.h:255: warning: left shift count >=3D width of type
> include/linux/mm.h:255: warning: integer constant is too large for =E2=
=80=98unsigned=20
> long=E2=80=99 type
> In file included=20
> from /usr/src/linux-iscsi/trunk/target/target/../include/iscsi_linux_=
defs.h:27,
>                 =20
> from /usr/src/linux-iscsi/trunk/target/target/../include/iscsi_crc.h:=
21,
>                 =20
> from /usr/src/linux-iscsi/trunk/target/target/../common/iscsi_crc.c:3=
5:
> include/linux/mm.h:437:2: error: #error SECTIONS_WIDTH+NODES_WIDTH+ZO=
NES_WIDTH=20
> > FLAGS_RESERVED
> In file included=20
> from /usr/src/linux-iscsi/trunk/target/target/../include/iscsi_linux_=
defs.h:27,
>                 =20
> from /usr/src/linux-iscsi/trunk/target/target/../include/iscsi_crc.h:=
21,
>                 =20
> from /usr/src/linux-iscsi/trunk/target/target/../common/iscsi_crc.c:3=
5:
> include/linux/mm.h: In function =E2=80=98lowmem_page_address=E2=80=99=
:
> include/linux/mm.h:539: warning: integer constant is too large for =E2=
=80=98unsigned=20
> long=E2=80=99 type
> include/linux/mm.h:539: warning: left shift count >=3D width of type
> include/linux/mm.h:539: warning: integer constant is too large for =E2=
=80=98unsigned=20
> long=E2=80=99 type
> include/linux/mm.h:539: warning: cast to pointer from integer of diff=
erent=20
> size
> In file included from include/linux/highmem.h:4,
>                 =20
> from /usr/src/linux-iscsi/trunk/target/target/../include/iscsi_linux_=
defs.h:36,
>                 =20
> from /usr/src/linux-iscsi/trunk/target/target/../include/iscsi_crc.h:=
21,
>                 =20
> from /usr/src/linux-iscsi/trunk/target/target/../common/iscsi_crc.c:3=
5:
> include/linux/fs.h: At top level:
> include/linux/fs.h:911: warning: =E2=80=98struct flock64=E2=80=99 dec=
lared inside parameter=20
> list
> include/linux/fs.h:911: warning: its scope is only this definition or=
=20
> declaration, which is probably not what you want
> include/linux/fs.h:913: warning: =E2=80=98struct flock64=E2=80=99 dec=
lared inside parameter=20
> list
> In file included from include/asm/cputime.h:26,
>                  from include/linux/sched.h:67,
>                  from include/asm/uaccess.h:7,
>                  from include/linux/uaccess.h:5,
>                  from include/linux/highmem.h:6,
>                 =20
> from /usr/src/linux-iscsi/trunk/target/target/../include/iscsi_linux_=
defs.h:36,
>                 =20
> from /usr/src/linux-iscsi/trunk/target/target/../include/iscsi_crc.h:=
21,
>                 =20
> from /usr/src/linux-iscsi/trunk/target/target/../common/iscsi_crc.c:3=
5:
> include/asm/time.h: In function =E2=80=98get_tb=E2=80=99:
> include/asm/time.h:135: error: implicit declaration of function =E2=80=
=98mftb=E2=80=99
> In file included from include/linux/uaccess.h:5,
>                  from include/linux/highmem.h:6,
>                 =20
> from /usr/src/linux-iscsi/trunk/target/target/../include/iscsi_linux_=
defs.h:36,
>                 =20
> from /usr/src/linux-iscsi/trunk/target/target/../include/iscsi_crc.h:=
21,
>                 =20
> from /usr/src/linux-iscsi/trunk/target/target/../common/iscsi_crc.c:3=
5:
> include/asm/uaccess.h: In function =E2=80=98copy_from_user=E2=80=99:
> include/asm/uaccess.h:342: warning: integer constant is too large=20
> for =E2=80=98unsigned long=E2=80=99 type
> include/asm/uaccess.h:342: warning: integer constant is too large=20
> for =E2=80=98unsigned long=E2=80=99 type
> include/asm/uaccess.h:343: warning: integer constant is too large=20
> for =E2=80=98unsigned long=E2=80=99 type
> include/asm/uaccess.h:343: warning: integer constant is too large=20
> for =E2=80=98unsigned long=E2=80=99 type
> include/asm/uaccess.h: In function =E2=80=98copy_to_user=E2=80=99:
> include/asm/uaccess.h:357: warning: integer constant is too large=20
> for =E2=80=98unsigned long=E2=80=99 type
> include/asm/uaccess.h:357: warning: integer constant is too large=20
> for =E2=80=98unsigned long=E2=80=99 type
> include/asm/uaccess.h:358: warning: integer constant is too large=20
> for =E2=80=98unsigned long=E2=80=99 type
> include/asm/uaccess.h:358: warning: integer constant is too large=20
> for =E2=80=98unsigned long=E2=80=99 type
> include/asm/uaccess.h: In function =E2=80=98clear_user=E2=80=99:
> include/asm/uaccess.h:452: warning: integer constant is too large=20
> for =E2=80=98unsigned long=E2=80=99 type
> include/asm/uaccess.h:452: warning: integer constant is too large=20
> for =E2=80=98unsigned long=E2=80=99 type
> include/asm/uaccess.h:453: warning: integer constant is too large=20
> for =E2=80=98unsigned long=E2=80=99 type
> include/asm/uaccess.h:453: warning: integer constant is too large=20
> for =E2=80=98unsigned long=E2=80=99 type
> make[3]: *** [/usr/src/linux-iscsi/trunk/target/target/../common/iscs=
i_crc.o]=20
> Error 1
> make[2]: *** [_module_/usr/src/linux-iscsi/trunk/target/target] Error=
 2
> make[2]: Leaving directory `/usr/src/ps3-linux'
> make[1]: *** [all] Error 2
> make[1]: Leaving directory `/usr/src/linux-iscsi/trunk/target/target'
> make: *** [kernel] Error 2
>=20
> thanks
>=20
> Marc
>=20
> Am Montag 04 Februar 2008 15:17:03 schrieb Nicholas A. Bellinger:
> > Greetings all,
> >
> > I have updated the wiki at:
> >
> > http://linux-iscsi.org/index.php/Playstation3/iSCSI
> >
> > and posted the first LIO target builds on the LIO Cluster:
> >
> > http://linux-iscsi.org/builds/ps3-linux/
> >
> > I will adding the documentation for both LIO SE on PS3-Linux, and t=
he
> > FC8 upgrade process, as the latter can still be a bit challenging f=
or
> > new users.
> >
> > Here is the info from the README:
> >
> > LIO Target iSCSI/SE for PS3-Linux v2.9.0.209
> >
> > I) Kernel module package
> >
> > iscsi-target-module-2.6.24-2.9.0.209-1.powerpc.rpm
> >
> > This modules are built for ppc64 and built with the toolkit for Fed=
ora Core
> > 8 ppc. This is gcc (GCC) 4.1.2 20070925 (Red Hat 4.1.2-33)
> >
> > This module has been tested with the latest ps3-linux.git and built=
 against
> > arch/powerpc/configs/ps3_defconfig.  To use the BD-ROM, your 2.6.24=
 kernel
> > must contain ps3rom-use-128-max-sector.diff.  Please see:
> >
> > http://git.kernel.org/?p=3Dlinux/kernel/git/geoff/ps3-linux.git;a=3D=
commit;h=3De8
> >2112af66a39d11bcb484de9cfa45f0d214c97f
> >
> > This module package should work with kernel-2.6.24-20080131.ppc64.r=
pm from
> > CELL-Linux-CL_20080201-ADDON.iso, but the BD-ROM will throw an exce=
ption
> > without ps3rom-use-128-max-sector.diff.  Please see the following l=
ink for
> > more information about the ADDON CD, and watch for an updated kerne=
l
> > package soon..
> >
> > http://www.kernel.org/pub/linux/kernel/people/geoff/cell/
> >
> > II) Userspace packages
> >
> > iscsi-target-tools-2.9.0.209-1.ppc.rpm
> > sbe-mibs-2.9.0.209-1.ppc.rpm
> >
> > Note that these are 32-bit and built on Fedora Core 8.
> >
> > Have fun!
> >
> > --nab
> >
> > _______________________________________________
> > cbe-oss-dev mailing list
> > cbe-oss-dev@ozlabs.org
> > https://ozlabs.org/mailman/listinfo/cbe-oss-dev
>=20
>=20
>=20
