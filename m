From: Rusty Trivial Russell <rusty@samba.org>
Subject: [TRIVIAL] Remove __NO_VERSION__ from 2.4
Date: Mon, 12 Aug 2002 11:50:50 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020811210612.B18882C0DD@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: Kai Germaschewski <kai.germaschewski@gmx.de>, Karsten Keil <kkeil@suse.de>, braam@clusterfs.com, davem@redhat.com, dledford@redhat.com, dwmw2@redhat.com, faith@redhat.com, greg@kroah.com, hpa@zytor.com, jaharkes@cs.cmu.edu, jffs-dev@axis.com, jhartmann@precisioninsight.com, laforge@gnumonks.org, linux-scsi@vger.kernel.org, mac@melware.de, perex@suse.cz, schwidefsky@de.ibm.com, trond.myklebust@fys.uio.no

[ BTW: rustcorp.com.au temporarily not resolving, using samba.org address ]

From:  Keith Owens <kaos@ocs.com.au>

  #define __NO_VERSION__ has not been required since 2.3 days.  Trivial
  change to remove all references to __NO_VERSION__, it just hits a lot
  of files.
  
   arch/s390x/kernel/exec32.c                  |    1 -
   drivers/char/agp/agpgart_fe.c               |    1 -
   drivers/char/drm-4.0/agpsupport.c           |    1 -
   drivers/char/drm-4.0/auth.c                 |    1 -
   drivers/char/drm-4.0/bufs.c                 |    1 -
   drivers/char/drm-4.0/context.c              |    1 -
   drivers/char/drm-4.0/ctxbitmap.c            |    1 -
   drivers/char/drm-4.0/dma.c                  |    1 -
   drivers/char/drm-4.0/drawable.c             |    1 -
   drivers/char/drm-4.0/fops.c                 |    1 -
   drivers/char/drm-4.0/gamma_dma.c            |    1 -
   drivers/char/drm-4.0/i810_bufs.c            |    1 -
   drivers/char/drm-4.0/i810_context.c         |    1 -
   drivers/char/drm-4.0/i810_dma.c             |    1 -
   drivers/char/drm-4.0/init.c                 |    1 -
   drivers/char/drm-4.0/ioctl.c                |    1 -
   drivers/char/drm-4.0/lists.c                |    1 -
   drivers/char/drm-4.0/lock.c                 |    1 -
   drivers/char/drm-4.0/memory.c               |    1 -
   drivers/char/drm-4.0/mga_bufs.c             |    1 -
   drivers/char/drm-4.0/mga_context.c          |    1 -
   drivers/char/drm-4.0/mga_dma.c              |    1 -
   drivers/char/drm-4.0/mga_state.c            |    1 -
   drivers/char/drm-4.0/proc.c                 |    1 -
   drivers/char/drm-4.0/r128_bufs.c            |    1 -
   drivers/char/drm-4.0/r128_cce.c             |    1 -
   drivers/char/drm-4.0/r128_context.c         |    1 -
   drivers/char/drm-4.0/r128_state.c           |    1 -
   drivers/char/drm-4.0/radeon_bufs.c          |    1 -
   drivers/char/drm-4.0/radeon_context.c       |    1 -
   drivers/char/drm-4.0/radeon_cp.c            |    1 -
   drivers/char/drm-4.0/radeon_state.c         |    1 -
   drivers/char/drm-4.0/tdfx_context.c         |    1 -
   drivers/char/drm-4.0/vm.c                   |    1 -
   drivers/char/drm/ati_pcigart.h              |    1 -
   drivers/char/drm/drm_agpsupport.h           |    1 -
   drivers/char/drm/drm_auth.h                 |    1 -
   drivers/char/drm/drm_bufs.h                 |    1 -
   drivers/char/drm/drm_context.h              |    1 -
   drivers/char/drm/drm_dma.h                  |    1 -
   drivers/char/drm/drm_drawable.h             |    1 -
   drivers/char/drm/drm_fops.h                 |    1 -
   drivers/char/drm/drm_init.h                 |    1 -
   drivers/char/drm/drm_ioctl.h                |    1 -
   drivers/char/drm/drm_lists.h                |    1 -
   drivers/char/drm/drm_lock.h                 |    1 -
   drivers/char/drm/drm_memory.h               |    1 -
   drivers/char/drm/drm_proc.h                 |    1 -
   drivers/char/drm/drm_scatter.h              |    1 -
   drivers/char/drm/drm_stub.h                 |    1 -
   drivers/char/drm/drm_vm.h                   |    1 -
   drivers/char/drm/gamma_dma.c                |    1 -
   drivers/char/drm/i810_dma.c                 |    1 -
   drivers/char/drm/mga_dma.c                  |    1 -
   drivers/char/drm/mga_state.c                |    1 -
   drivers/char/drm/mga_warp.c                 |    1 -
   drivers/char/drm/r128_cce.c                 |    1 -
   drivers/char/drm/r128_state.c               |    1 -
   drivers/char/drm/radeon_cp.c                |    1 -
   drivers/char/drm/radeon_state.c             |    1 -
   drivers/char/drm/sis_ds.c                   |    1 -
   drivers/char/drm/sis_mm.c                   |    1 -
   drivers/char/ftape/lowlevel/ftape_syms.c    |    1 -
   drivers/char/ftape/zftape/zftape-ctl.c      |    1 -
   drivers/char/ftape/zftape/zftape_syms.c     |    1 -
   drivers/char/rio/rioboot.c                  |    1 -
   drivers/char/rio/riocmd.c                   |    1 -
   drivers/char/rio/rioctrl.c                  |    1 -
   drivers/char/rio/rioinit.c                  |    1 -
   drivers/char/rio/riointr.c                  |    1 -
   drivers/char/rio/rioparam.c                 |    1 -
   drivers/char/rio/rioroute.c                 |    1 -
   drivers/char/rio/riotable.c                 |    1 -
   drivers/char/rio/riotty.c                   |    1 -
   drivers/fc4/fc_syms.c                       |    1 -
   drivers/ide/ide-features.c                  |    1 -
   drivers/ide/ide-taskfile.c                  |    1 -
   drivers/isdn/act2000/act2000_isa.c          |    1 -
   drivers/isdn/act2000/capi.c                 |    1 -
   drivers/isdn/divert/divert_procfs.c         |    1 -
   drivers/isdn/eicon/eicon_idi.c              |    1 -
   drivers/isdn/eicon/linchr.c                 |    1 -
   drivers/isdn/hisax/amd7930.c                |    1 -
   drivers/isdn/hisax/arcofi.c                 |    1 -
   drivers/isdn/hisax/asuscom.c                |    1 -
   drivers/isdn/hisax/avm_a1.c                 |    1 -
   drivers/isdn/hisax/avm_a1p.c                |    1 -
   drivers/isdn/hisax/avm_pci.c                |    1 -
   drivers/isdn/hisax/bkm_a4t.c                |    2 --
   drivers/isdn/hisax/bkm_a8.c                 |    2 --
   drivers/isdn/hisax/callc.c                  |    1 -
   drivers/isdn/hisax/diva.c                   |    1 -
   drivers/isdn/hisax/elsa.c                   |    1 -
   drivers/isdn/hisax/fsm.c                    |    1 -
   drivers/isdn/hisax/gazel.c                  |    1 -
   drivers/isdn/hisax/hfc_2bds0.c              |    1 -
   drivers/isdn/hisax/hfc_2bs0.c               |    1 -
   drivers/isdn/hisax/hfc_pci.c                |    1 -
   drivers/isdn/hisax/hfc_sx.c                 |    1 -
   drivers/isdn/hisax/hfcscard.c               |    1 -
   drivers/isdn/hisax/hscx.c                   |    1 -
   drivers/isdn/hisax/icc.c                    |    1 -
   drivers/isdn/hisax/isac.c                   |    1 -
   drivers/isdn/hisax/isar.c                   |    1 -
   drivers/isdn/hisax/isdnl1.c                 |    1 -
   drivers/isdn/hisax/isdnl2.c                 |    1 -
   drivers/isdn/hisax/isdnl3.c                 |    1 -
   drivers/isdn/hisax/isurf.c                  |    1 -
   drivers/isdn/hisax/ix1_micro.c              |    1 -
   drivers/isdn/hisax/jade.c                   |    1 -
   drivers/isdn/hisax/l3_1tr6.c                |    1 -
   drivers/isdn/hisax/l3dss1.c                 |    1 -
   drivers/isdn/hisax/l3ni1.c                  |    1 -
   drivers/isdn/hisax/lmgr.c                   |    1 -
   drivers/isdn/hisax/mic.c                    |    1 -
   drivers/isdn/hisax/netjet.c                 |    1 -
   drivers/isdn/hisax/niccy.c                  |    1 -
   drivers/isdn/hisax/nj_s.c                   |    1 -
   drivers/isdn/hisax/nj_u.c                   |    1 -
   drivers/isdn/hisax/q931.c                   |    1 -
   drivers/isdn/hisax/s0box.c                  |    1 -
   drivers/isdn/hisax/saphir.c                 |    1 -
   drivers/isdn/hisax/sedlbauer.c              |    1 -
   drivers/isdn/hisax/sportster.c              |    1 -
   drivers/isdn/hisax/tei.c                    |    1 -
   drivers/isdn/hisax/teleint.c                |    1 -
   drivers/isdn/hisax/teles0.c                 |    1 -
   drivers/isdn/hisax/teles3.c                 |    1 -
   drivers/isdn/hisax/telespci.c               |    1 -
   drivers/isdn/hisax/w6692.c                  |    1 -
   drivers/isdn/hysdn/hysdn_net.c              |    1 -
   drivers/isdn/hysdn/hysdn_procconf.c         |    1 -
   drivers/isdn/hysdn/hysdn_proclog.c          |    1 -
   drivers/isdn/pcbit/drv.c                    |    2 --
   drivers/isdn/sc/command.c                   |    1 -
   drivers/isdn/sc/event.c                     |    1 -
   drivers/isdn/sc/interrupt.c                 |    1 -
   drivers/isdn/sc/ioctl.c                     |    1 -
   drivers/isdn/sc/message.c                   |    1 -
   drivers/isdn/sc/packet.c                    |    1 -
   drivers/isdn/sc/shmem.c                     |    1 -
   drivers/isdn/sc/timer.c                     |    1 -
   drivers/media/radio/miropcm20-rds-core.c    |    2 --
   drivers/media/video/bttv-cards.c            |    2 --
   drivers/media/video/bttv-if.c               |    2 --
   drivers/mtd/nftlmount.c                     |    1 -
   drivers/pcmcia/bulkmem.c                    |    2 --
   drivers/pcmcia/cardbus.c                    |    3 ---
   drivers/pcmcia/cistpl.c                     |    2 --
   drivers/pcmcia/rsrc_mgr.c                   |    2 --
   drivers/pnp/isapnp_proc.c                   |    2 --
   drivers/s390/block/xpram.c                  |    1 -
   drivers/s390/char/tapeblock.c               |    1 -
   drivers/s390/char/tapechar.c                |    1 -
   drivers/s390/net/ctctty.c                   |    1 -
   drivers/scsi/aic7xxx/aic7xxx_osm.h          |    1 -
   drivers/scsi/constants.c                    |    1 -
   drivers/scsi/hosts.c                        |    1 -
   drivers/scsi/pcmcia/Makefile                |    6 +++---
   drivers/scsi/scsi_dma.c                     |    1 -
   drivers/scsi/scsi_error.c                   |    1 -
   drivers/scsi/scsi_ioctl.c                   |    1 -
   drivers/scsi/scsi_lib.c                     |    1 -
   drivers/scsi/scsi_merge.c                   |    1 -
   drivers/scsi/scsi_obsolete.c                |    1 -
   drivers/scsi/scsi_proc.c                    |    1 -
   drivers/scsi/scsi_queue.c                   |    1 -
   drivers/scsi/scsi_scan.c                    |    1 -
   drivers/scsi/scsi_syms.c                    |    1 -
   drivers/scsi/scsicam.c                      |    1 -
   drivers/sound/audio_syms.c                  |    2 --
   drivers/sound/emu10k1/audio.c               |    1 -
   drivers/sound/emu10k1/midi.c                |    1 -
   drivers/sound/emu10k1/mixer.c               |    1 -
   drivers/sound/emu10k1/passthrough.c         |    1 -
   drivers/sound/midi_syms.c                   |    2 --
   drivers/sound/nm256_audio.c                 |    1 -
   drivers/sound/sequencer_syms.c              |    2 --
   drivers/usb/inode.c                         |    1 -
   drivers/usb/usbvideo.c                      |    1 -
   fs/autofs/inode.c                           |    1 -
   fs/autofs4/inode.c                          |    1 -
   fs/coda/inode.c                             |    1 -
   fs/coda/pioctl.c                            |    1 -
   fs/coda/sysctl.c                            |    1 -
   fs/exec.c                                   |    1 -
   fs/intermezzo/cache.c                       |    1 -
   fs/intermezzo/dcache.c                      |    1 -
   fs/intermezzo/dir.c                         |    1 -
   fs/intermezzo/ext_attr.c                    |    1 -
   fs/intermezzo/file.c                        |    1 -
   fs/intermezzo/inode.c                       |    1 -
   fs/intermezzo/kml.c                         |    1 -
   fs/intermezzo/kml_decode.c                  |    1 -
   fs/intermezzo/kml_reint.c                   |    1 -
   fs/intermezzo/kml_setup.c                   |    1 -
   fs/intermezzo/methods.c                     |    1 -
   fs/intermezzo/super.c                       |    1 -
   fs/intermezzo/sysctl.c                      |    1 -
   fs/jffs/intrep.c                            |    1 -
   fs/jffs/jffs_fm.c                           |    1 -
   fs/lockd/lockd_syms.c                       |    1 -
   fs/msdos/namei.c                            |    1 -
   fs/nfsd/nfssvc.c                            |    1 -
   fs/nfsd/stats.c                             |    1 -
   fs/nfsd/vfs.c                               |    1 -
   fs/proc/generic.c                           |    1 -
   fs/proc/inode.c                             |    1 -
   fs/super.c                                  |    1 -
   net/ipv4/netfilter/ip_conntrack_core.c      |    1 -
   net/ipv4/netfilter/ip_conntrack_proto_tcp.c |    1 -
   net/ipv4/netfilter/ip_nat_core.c            |    1 -
   net/ipv4/netfilter/ip_nat_rule.c            |    1 -
   net/ipv6/icmp.c                             |    1 -
   net/ipv6/ipv6_sockglue.c                    |    1 -
   net/ipv6/mcast.c                            |    1 -
   net/ipv6/ndisc.c                            |    1 -
   net/ipv6/sit.c                              |    1 -
   net/ipv6/tcp_ipv6.c                         |    1 -
   net/irda/irproc.c                           |    1 -
   net/netrom/nr_dev.c                         |    1 -
   net/rose/rose_dev.c                         |    1 -
   net/sunrpc/stats.c                          |    1 -
   net/sunrpc/sunrpc_syms.c                    |    1 -
   net/sunrpc/sysctl.c                         |    1 -
   225 files changed, 3 insertions, 242 deletions
  

--- trivial-2.4.20-pre1/arch/s390x/kernel/exec32.c.orig	2002-08-12 11:47:49.000000000 +1000
+++ trivial-2.4.20-pre1/arch/s390x/kernel/exec32.c	2002-08-12 11:47:56.000000000 +1000
@@ -20,7 +20,6 @@
 #include <linux/pagemap.h>
 #include <linux/highmem.h>
 #include <linux/spinlock.h>
-#define __NO_VERSION__
 #include <linux/module.h>
 
 #include <asm/uaccess.h>
--- trivial-2.4.20-pre1/drivers/char/agp/agpgart_fe.c.orig	2002-08-12 11:47:49.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/agp/agpgart_fe.c	2002-08-12 11:47:56.000000000 +1000
@@ -24,7 +24,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/version.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
--- trivial-2.4.20-pre1/drivers/char/drm-4.0/agpsupport.c.orig	2002-08-12 11:47:49.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm-4.0/agpsupport.c	2002-08-12 11:47:56.000000000 +1000
@@ -28,7 +28,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 #include <linux/module.h>
 #if LINUX_VERSION_CODE < 0x020400
--- trivial-2.4.20-pre1/drivers/char/drm-4.0/auth.c.orig	2002-08-12 11:47:49.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm-4.0/auth.c	2002-08-12 11:47:56.000000000 +1000
@@ -29,7 +29,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 
 static int drm_hash_magic(drm_magic_t magic)
--- trivial-2.4.20-pre1/drivers/char/drm-4.0/bufs.c.orig	2002-08-12 11:47:49.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm-4.0/bufs.c	2002-08-12 11:47:56.000000000 +1000
@@ -29,7 +29,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/config.h>
 #include "drmP.h"
 #include "linux/un.h"
--- trivial-2.4.20-pre1/drivers/char/drm-4.0/context.c.orig	2002-08-12 11:47:49.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm-4.0/context.c	2002-08-12 11:47:56.000000000 +1000
@@ -29,7 +29,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 
 static int drm_init_queue(drm_device_t *dev, drm_queue_t *q, drm_ctx_t *ctx)
--- trivial-2.4.20-pre1/drivers/char/drm-4.0/ctxbitmap.c.orig	2002-08-12 11:47:49.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm-4.0/ctxbitmap.c	2002-08-12 11:47:56.000000000 +1000
@@ -28,7 +28,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 
 void drm_ctxbitmap_free(drm_device_t *dev, int ctx_handle)
--- trivial-2.4.20-pre1/drivers/char/drm-4.0/dma.c.orig	2002-08-12 11:47:49.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm-4.0/dma.c	2002-08-12 11:47:56.000000000 +1000
@@ -29,7 +29,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 
 #include <linux/interrupt.h>	/* For task queue support */
--- trivial-2.4.20-pre1/drivers/char/drm-4.0/drawable.c.orig	2002-08-12 11:47:49.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm-4.0/drawable.c	2002-08-12 11:47:56.000000000 +1000
@@ -29,7 +29,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 
 int drm_adddraw(struct inode *inode, struct file *filp, unsigned int cmd,
--- trivial-2.4.20-pre1/drivers/char/drm-4.0/fops.c.orig	2002-08-12 11:47:49.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm-4.0/fops.c	2002-08-12 11:47:56.000000000 +1000
@@ -30,7 +30,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 #include <linux/poll.h>
 
--- trivial-2.4.20-pre1/drivers/char/drm-4.0/gamma_dma.c.orig	2002-08-12 11:47:49.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm-4.0/gamma_dma.c	2002-08-12 11:47:56.000000000 +1000
@@ -29,7 +29,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 #include "gamma_drv.h"
 
--- trivial-2.4.20-pre1/drivers/char/drm-4.0/i810_bufs.c.orig	2002-08-12 11:47:49.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm-4.0/i810_bufs.c	2002-08-12 11:47:56.000000000 +1000
@@ -29,7 +29,6 @@
  * 
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 #include "i810_drv.h"
 #include "linux/un.h"
--- trivial-2.4.20-pre1/drivers/char/drm-4.0/i810_context.c.orig	2002-08-12 11:47:49.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm-4.0/i810_context.c	2002-08-12 11:47:56.000000000 +1000
@@ -29,7 +29,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 #include "i810_drv.h"
 
--- trivial-2.4.20-pre1/drivers/char/drm-4.0/i810_dma.c.orig	2002-08-12 11:47:49.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm-4.0/i810_dma.c	2002-08-12 11:47:56.000000000 +1000
@@ -30,7 +30,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 #include "i810_drv.h"
 #include <linux/interrupt.h>	/* For task queue support */
--- trivial-2.4.20-pre1/drivers/char/drm-4.0/init.c.orig	2002-08-12 11:47:49.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm-4.0/init.c	2002-08-12 11:47:56.000000000 +1000
@@ -29,7 +29,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 
 int			      drm_flags		= 0;
--- trivial-2.4.20-pre1/drivers/char/drm-4.0/ioctl.c.orig	2002-08-12 11:47:49.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm-4.0/ioctl.c	2002-08-12 11:47:56.000000000 +1000
@@ -29,7 +29,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 
 int drm_irq_busid(struct inode *inode, struct file *filp, unsigned int cmd,
--- trivial-2.4.20-pre1/drivers/char/drm-4.0/lists.c.orig	2002-08-12 11:47:49.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm-4.0/lists.c	2002-08-12 11:47:56.000000000 +1000
@@ -29,7 +29,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 
 int drm_waitlist_create(drm_waitlist_t *bl, int count)
--- trivial-2.4.20-pre1/drivers/char/drm-4.0/lock.c.orig	2002-08-12 11:47:49.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm-4.0/lock.c	2002-08-12 11:47:56.000000000 +1000
@@ -29,7 +29,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 
 int drm_block(struct inode *inode, struct file *filp, unsigned int cmd,
--- trivial-2.4.20-pre1/drivers/char/drm-4.0/memory.c.orig	2002-08-12 11:47:49.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm-4.0/memory.c	2002-08-12 11:47:56.000000000 +1000
@@ -29,7 +29,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/config.h>
 #include "drmP.h"
 #include <linux/wrapper.h>
--- trivial-2.4.20-pre1/drivers/char/drm-4.0/mga_bufs.c.orig	2002-08-12 11:47:49.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm-4.0/mga_bufs.c	2002-08-12 11:47:56.000000000 +1000
@@ -29,7 +29,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 #include "mga_drv.h"
 #include "linux/un.h"
--- trivial-2.4.20-pre1/drivers/char/drm-4.0/mga_context.c.orig	2002-08-12 11:47:49.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm-4.0/mga_context.c	2002-08-12 11:47:56.000000000 +1000
@@ -29,7 +29,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 #include "mga_drv.h"
 
--- trivial-2.4.20-pre1/drivers/char/drm-4.0/mga_dma.c.orig	2002-08-12 11:47:49.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm-4.0/mga_dma.c	2002-08-12 11:47:56.000000000 +1000
@@ -30,7 +30,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 #include "mga_drv.h"
 
--- trivial-2.4.20-pre1/drivers/char/drm-4.0/mga_state.c.orig	2002-08-12 11:47:49.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm-4.0/mga_state.c	2002-08-12 11:47:56.000000000 +1000
@@ -29,7 +29,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 #include "mga_drv.h"
 #include "drm.h"
--- trivial-2.4.20-pre1/drivers/char/drm-4.0/proc.c.orig	2002-08-12 11:47:49.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm-4.0/proc.c	2002-08-12 11:47:56.000000000 +1000
@@ -28,7 +28,6 @@
  *    Rickard E. (Rik) Faith <faith@valinux.com>
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 
 static struct proc_dir_entry *drm_root	   = NULL;
--- trivial-2.4.20-pre1/drivers/char/drm-4.0/r128_bufs.c.orig	2002-08-12 11:47:49.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm-4.0/r128_bufs.c	2002-08-12 11:47:56.000000000 +1000
@@ -30,7 +30,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/config.h>
 #include "drmP.h"
 #include "r128_drv.h"
--- trivial-2.4.20-pre1/drivers/char/drm-4.0/r128_cce.c.orig	2002-08-12 11:47:49.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm-4.0/r128_cce.c	2002-08-12 11:47:56.000000000 +1000
@@ -29,7 +29,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 #include "r128_drv.h"
 
--- trivial-2.4.20-pre1/drivers/char/drm-4.0/r128_context.c.orig	2002-08-12 11:47:49.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm-4.0/r128_context.c	2002-08-12 11:47:56.000000000 +1000
@@ -28,7 +28,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 #include "r128_drv.h"
 
--- trivial-2.4.20-pre1/drivers/char/drm-4.0/r128_state.c.orig	2002-08-12 11:47:49.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm-4.0/r128_state.c	2002-08-12 11:47:56.000000000 +1000
@@ -28,7 +28,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 #include "r128_drv.h"
 #include "drm.h"
--- trivial-2.4.20-pre1/drivers/char/drm-4.0/radeon_bufs.c.orig	2002-08-12 11:47:49.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm-4.0/radeon_bufs.c	2002-08-12 11:47:56.000000000 +1000
@@ -29,7 +29,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/config.h>
 #include "drmP.h"
 #include "radeon_drv.h"
--- trivial-2.4.20-pre1/drivers/char/drm-4.0/radeon_context.c.orig	2002-08-12 11:47:49.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm-4.0/radeon_context.c	2002-08-12 11:47:56.000000000 +1000
@@ -28,7 +28,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 #include "radeon_drv.h"
 
--- trivial-2.4.20-pre1/drivers/char/drm-4.0/radeon_cp.c.orig	2002-08-12 11:47:49.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm-4.0/radeon_cp.c	2002-08-12 11:47:56.000000000 +1000
@@ -29,7 +29,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 #include "radeon_drv.h"
 
--- trivial-2.4.20-pre1/drivers/char/drm-4.0/radeon_state.c.orig	2002-08-12 11:47:49.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm-4.0/radeon_state.c	2002-08-12 11:47:56.000000000 +1000
@@ -28,7 +28,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 #include "radeon_drv.h"
 #include "drm.h"
--- trivial-2.4.20-pre1/drivers/char/drm-4.0/tdfx_context.c.orig	2002-08-12 11:47:49.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm-4.0/tdfx_context.c	2002-08-12 11:47:56.000000000 +1000
@@ -30,7 +30,6 @@
  * 
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 #include "tdfx_drv.h"
 
--- trivial-2.4.20-pre1/drivers/char/drm-4.0/vm.c.orig	2002-08-12 11:47:49.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm-4.0/vm.c	2002-08-12 11:47:56.000000000 +1000
@@ -29,7 +29,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 
 struct vm_operations_struct   drm_vm_ops = {
--- trivial-2.4.20-pre1/drivers/char/drm/ati_pcigart.h.orig	2002-08-12 11:47:49.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm/ati_pcigart.h	2002-08-12 11:47:56.000000000 +1000
@@ -27,7 +27,6 @@
  *   Gareth Hughes <gareth@valinux.com>
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 
 #if PAGE_SIZE == 8192
--- trivial-2.4.20-pre1/drivers/char/drm/drm_agpsupport.h.orig	2002-08-12 11:47:50.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm/drm_agpsupport.h	2002-08-12 11:47:56.000000000 +1000
@@ -29,7 +29,6 @@
  *    Gareth Hughes <gareth@valinux.com>
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 #include <linux/module.h>
 
--- trivial-2.4.20-pre1/drivers/char/drm/drm_auth.h.orig	2002-08-12 11:47:50.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm/drm_auth.h	2002-08-12 11:47:56.000000000 +1000
@@ -29,7 +29,6 @@
  *    Gareth Hughes <gareth@valinux.com>
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 
 static int DRM(hash_magic)(drm_magic_t magic)
--- trivial-2.4.20-pre1/drivers/char/drm/drm_bufs.h.orig	2002-08-12 11:47:50.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm/drm_bufs.h	2002-08-12 11:47:56.000000000 +1000
@@ -29,7 +29,6 @@
  *    Gareth Hughes <gareth@valinux.com>
  */
 
-#define __NO_VERSION__
 #include <linux/vmalloc.h>
 #include "drmP.h"
 
--- trivial-2.4.20-pre1/drivers/char/drm/drm_context.h.orig	2002-08-12 11:47:50.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm/drm_context.h	2002-08-12 11:47:56.000000000 +1000
@@ -33,7 +33,6 @@
  *		needed by SiS driver's memory management.
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 
 #if __HAVE_CTX_BITMAP
--- trivial-2.4.20-pre1/drivers/char/drm/drm_dma.h.orig	2002-08-12 11:47:50.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm/drm_dma.h	2002-08-12 11:47:56.000000000 +1000
@@ -29,7 +29,6 @@
  *    Gareth Hughes <gareth@valinux.com>
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 
 #include <linux/interrupt.h>	/* For task queue support */
--- trivial-2.4.20-pre1/drivers/char/drm/drm_drawable.h.orig	2002-08-12 11:47:50.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm/drm_drawable.h	2002-08-12 11:47:56.000000000 +1000
@@ -29,7 +29,6 @@
  *    Gareth Hughes <gareth@valinux.com>
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 
 int DRM(adddraw)(struct inode *inode, struct file *filp,
--- trivial-2.4.20-pre1/drivers/char/drm/drm_fops.h.orig	2002-08-12 11:47:50.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm/drm_fops.h	2002-08-12 11:47:56.000000000 +1000
@@ -30,7 +30,6 @@
  *    Gareth Hughes <gareth@valinux.com>
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 #include <linux/poll.h>
 
--- trivial-2.4.20-pre1/drivers/char/drm/drm_init.h.orig	2002-08-12 11:47:50.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm/drm_init.h	2002-08-12 11:47:56.000000000 +1000
@@ -29,7 +29,6 @@
  *    Gareth Hughes <gareth@valinux.com>
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 
 #if 0
--- trivial-2.4.20-pre1/drivers/char/drm/drm_ioctl.h.orig	2002-08-12 11:47:50.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm/drm_ioctl.h	2002-08-12 11:47:56.000000000 +1000
@@ -29,7 +29,6 @@
  *    Gareth Hughes <gareth@valinux.com>
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 
 int DRM(irq_busid)(struct inode *inode, struct file *filp,
--- trivial-2.4.20-pre1/drivers/char/drm/drm_lists.h.orig	2002-08-12 11:47:50.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm/drm_lists.h	2002-08-12 11:47:56.000000000 +1000
@@ -29,7 +29,6 @@
  *    Gareth Hughes <gareth@valinux.com>
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 
 #if __HAVE_DMA_WAITLIST
--- trivial-2.4.20-pre1/drivers/char/drm/drm_lock.h.orig	2002-08-12 11:47:50.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm/drm_lock.h	2002-08-12 11:47:56.000000000 +1000
@@ -29,7 +29,6 @@
  *    Gareth Hughes <gareth@valinux.com>
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 
 int DRM(block)(struct inode *inode, struct file *filp, unsigned int cmd,
--- trivial-2.4.20-pre1/drivers/char/drm/drm_memory.h.orig	2002-08-12 11:47:50.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm/drm_memory.h	2002-08-12 11:47:56.000000000 +1000
@@ -29,7 +29,6 @@
  *    Gareth Hughes <gareth@valinux.com>
  */
 
-#define __NO_VERSION__
 #include <linux/config.h>
 #include "drmP.h"
 #include <linux/wrapper.h>
--- trivial-2.4.20-pre1/drivers/char/drm/drm_proc.h.orig	2002-08-12 11:47:50.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm/drm_proc.h	2002-08-12 11:47:56.000000000 +1000
@@ -33,7 +33,6 @@
  *    the problem with the proc files not outputting all their information.
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 
 static int	   DRM(name_info)(char *buf, char **start, off_t offset,
--- trivial-2.4.20-pre1/drivers/char/drm/drm_scatter.h.orig	2002-08-12 11:47:50.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm/drm_scatter.h	2002-08-12 11:47:56.000000000 +1000
@@ -27,7 +27,6 @@
  *   Gareth Hughes <gareth@valinux.com>
  */
 
-#define __NO_VERSION__
 #include <linux/config.h>
 #include <linux/vmalloc.h>
 #include "drmP.h"
--- trivial-2.4.20-pre1/drivers/char/drm/drm_stub.h.orig	2002-08-12 11:47:50.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm/drm_stub.h	2002-08-12 11:47:56.000000000 +1000
@@ -28,7 +28,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 
 #if LINUX_VERSION_CODE < 0x020400
--- trivial-2.4.20-pre1/drivers/char/drm/drm_vm.h.orig	2002-08-12 11:47:50.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm/drm_vm.h	2002-08-12 11:47:56.000000000 +1000
@@ -29,7 +29,6 @@
  *    Gareth Hughes <gareth@valinux.com>
  */
 
-#define __NO_VERSION__
 #include "drmP.h"
 
 struct vm_operations_struct   DRM(vm_ops) = {
--- trivial-2.4.20-pre1/drivers/char/drm/gamma_dma.c.orig	2002-08-12 11:47:50.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm/gamma_dma.c	2002-08-12 11:47:56.000000000 +1000
@@ -29,7 +29,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include "gamma.h"
 #include "drmP.h"
 #include "gamma_drv.h"
--- trivial-2.4.20-pre1/drivers/char/drm/i810_dma.c.orig	2002-08-12 11:47:50.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm/i810_dma.c	2002-08-12 11:47:56.000000000 +1000
@@ -30,7 +30,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include "i810.h"
 #include "drmP.h"
 #include "i810_drv.h"
--- trivial-2.4.20-pre1/drivers/char/drm/mga_dma.c.orig	2002-08-12 11:47:50.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm/mga_dma.c	2002-08-12 11:47:56.000000000 +1000
@@ -33,7 +33,6 @@
  *    Gareth Hughes <gareth@valinux.com>
  */
 
-#define __NO_VERSION__
 #include "mga.h"
 #include "drmP.h"
 #include "mga_drv.h"
--- trivial-2.4.20-pre1/drivers/char/drm/mga_state.c.orig	2002-08-12 11:47:50.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm/mga_state.c	2002-08-12 11:47:56.000000000 +1000
@@ -32,7 +32,6 @@
  *    Gareth Hughes <gareth@valinux.com>
  */
 
-#define __NO_VERSION__
 #include "mga.h"
 #include "drmP.h"
 #include "mga_drv.h"
--- trivial-2.4.20-pre1/drivers/char/drm/mga_warp.c.orig	2002-08-12 11:47:50.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm/mga_warp.c	2002-08-12 11:47:56.000000000 +1000
@@ -27,7 +27,6 @@
  *    Gareth Hughes <gareth@valinux.com>
  */
 
-#define __NO_VERSION__
 #include "mga.h"
 #include "drmP.h"
 #include "mga_drv.h"
--- trivial-2.4.20-pre1/drivers/char/drm/r128_cce.c.orig	2002-08-12 11:47:50.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm/r128_cce.c	2002-08-12 11:47:56.000000000 +1000
@@ -28,7 +28,6 @@
  *    Gareth Hughes <gareth@valinux.com>
  */
 
-#define __NO_VERSION__
 #include "r128.h"
 #include "drmP.h"
 #include "r128_drv.h"
--- trivial-2.4.20-pre1/drivers/char/drm/r128_state.c.orig	2002-08-12 11:47:50.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm/r128_state.c	2002-08-12 11:47:56.000000000 +1000
@@ -27,7 +27,6 @@
  *    Gareth Hughes <gareth@valinux.com>
  */
 
-#define __NO_VERSION__
 #include "r128.h"
 #include "drmP.h"
 #include "r128_drv.h"
--- trivial-2.4.20-pre1/drivers/char/drm/radeon_cp.c.orig	2002-08-12 11:47:50.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm/radeon_cp.c	2002-08-12 11:47:56.000000000 +1000
@@ -28,7 +28,6 @@
  *    Gareth Hughes <gareth@valinux.com>
  */
 
-#define __NO_VERSION__
 #include "radeon.h"
 #include "drmP.h"
 #include "radeon_drv.h"
--- trivial-2.4.20-pre1/drivers/char/drm/radeon_state.c.orig	2002-08-12 11:47:50.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm/radeon_state.c	2002-08-12 11:47:56.000000000 +1000
@@ -27,7 +27,6 @@
  *    Kevin E. Martin <martin@valinux.com>
  */
 
-#define __NO_VERSION__
 #include "radeon.h"
 #include "drmP.h"
 #include "radeon_drv.h"
--- trivial-2.4.20-pre1/drivers/char/drm/sis_ds.c.orig	2002-08-12 11:47:50.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm/sis_ds.c	2002-08-12 11:47:56.000000000 +1000
@@ -28,7 +28,6 @@
  * 
  */
 
-#define __NO_VERSION__
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
--- trivial-2.4.20-pre1/drivers/char/drm/sis_mm.c.orig	2002-08-12 11:47:50.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/drm/sis_mm.c	2002-08-12 11:47:56.000000000 +1000
@@ -28,7 +28,6 @@
  * 
  */
 
-#define __NO_VERSION__
 #include "sis.h"
 #include <linux/sisfb.h>
 #include "drmP.h"
--- trivial-2.4.20-pre1/drivers/char/ftape/lowlevel/ftape_syms.c.orig	2002-08-12 11:47:50.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/ftape/lowlevel/ftape_syms.c	2002-08-12 11:47:56.000000000 +1000
@@ -26,7 +26,6 @@
  */
 
 #include <linux/config.h>
-#define __NO_VERSION__
 #include <linux/module.h>
 
 #include <linux/ftape.h>
--- trivial-2.4.20-pre1/drivers/char/ftape/zftape/zftape-ctl.c.orig	2002-08-12 11:47:50.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/ftape/zftape/zftape-ctl.c	2002-08-12 11:47:56.000000000 +1000
@@ -27,7 +27,6 @@
 #include <linux/config.h>
 #include <linux/errno.h>
 #include <linux/mm.h>
-#define __NO_VERSION__
 #include <linux/module.h>
 #include <linux/fcntl.h>
 
--- trivial-2.4.20-pre1/drivers/char/ftape/zftape/zftape_syms.c.orig	2002-08-12 11:47:50.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/ftape/zftape/zftape_syms.c	2002-08-12 11:47:56.000000000 +1000
@@ -24,7 +24,6 @@
  *      the ftape floppy tape driver exports 
  */		 
 
-#define __NO_VERSION__
 #include <linux/module.h>
 
 #include <linux/zftape.h>
--- trivial-2.4.20-pre1/drivers/char/rio/rioboot.c.orig	2002-08-12 11:47:50.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/rio/rioboot.c	2002-08-12 11:47:56.000000000 +1000
@@ -34,7 +34,6 @@
 static char *_rioboot_c_sccs_ = "@(#)rioboot.c	1.3";
 #endif
 
-#define __NO_VERSION__
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
--- trivial-2.4.20-pre1/drivers/char/rio/riocmd.c.orig	2002-08-12 11:47:50.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/rio/riocmd.c	2002-08-12 11:47:56.000000000 +1000
@@ -34,7 +34,6 @@
 static char *_riocmd_c_sccs_ = "@(#)riocmd.c	1.2";
 #endif
 
-#define __NO_VERSION__
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
--- trivial-2.4.20-pre1/drivers/char/rio/rioctrl.c.orig	2002-08-12 11:47:50.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/rio/rioctrl.c	2002-08-12 11:47:56.000000000 +1000
@@ -34,7 +34,6 @@
 #endif
 
 
-#define __NO_VERSION__
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
--- trivial-2.4.20-pre1/drivers/char/rio/rioinit.c.orig	2002-08-12 11:47:50.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/rio/rioinit.c	2002-08-12 11:47:56.000000000 +1000
@@ -33,7 +33,6 @@
 static char *_rioinit_c_sccs_ = "@(#)rioinit.c	1.3";
 #endif
 
-#define __NO_VERSION__
 #include <linux/config.h>
 #include <linux/module.h>
 #include <linux/slab.h>
--- trivial-2.4.20-pre1/drivers/char/rio/riointr.c.orig	2002-08-12 11:47:50.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/rio/riointr.c	2002-08-12 11:47:56.000000000 +1000
@@ -34,7 +34,6 @@
 #endif
 
 
-#define __NO_VERSION__
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
--- trivial-2.4.20-pre1/drivers/char/rio/rioparam.c.orig	2002-08-12 11:47:50.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/rio/rioparam.c	2002-08-12 11:47:56.000000000 +1000
@@ -34,7 +34,6 @@
 static char *_rioparam_c_sccs_ = "@(#)rioparam.c	1.3";
 #endif
 
-#define __NO_VERSION__
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
--- trivial-2.4.20-pre1/drivers/char/rio/rioroute.c.orig	2002-08-12 11:47:50.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/rio/rioroute.c	2002-08-12 11:47:56.000000000 +1000
@@ -33,7 +33,6 @@
 static char *_rioroute_c_sccs_ = "@(#)rioroute.c	1.3";
 #endif
 
-#define __NO_VERSION__
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
--- trivial-2.4.20-pre1/drivers/char/rio/riotable.c.orig	2002-08-12 11:47:50.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/rio/riotable.c	2002-08-12 11:47:56.000000000 +1000
@@ -33,7 +33,6 @@
 static char *_riotable_c_sccs_ = "@(#)riotable.c	1.2";
 #endif
 
-#define __NO_VERSION__
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
--- trivial-2.4.20-pre1/drivers/char/rio/riotty.c.orig	2002-08-12 11:47:50.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/char/rio/riotty.c	2002-08-12 11:47:56.000000000 +1000
@@ -36,7 +36,6 @@
 
 #define __EXPLICIT_DEF_H__
 
-#define __NO_VERSION__
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
--- trivial-2.4.20-pre1/drivers/fc4/fc_syms.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/fc4/fc_syms.c	2002-08-12 11:47:56.000000000 +1000
@@ -2,7 +2,6 @@
  * We should not even be trying to compile this if we are not doing
  * a module.
  */
-#define __NO_VERSION__
 #include <linux/config.h>
 #include <linux/module.h>
 
--- trivial-2.4.20-pre1/drivers/ide/ide-features.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/ide/ide-features.c	2002-08-12 11:47:56.000000000 +1000
@@ -15,7 +15,6 @@
  */
 
 #include <linux/config.h>
-#define __NO_VERSION__
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/string.h>
--- trivial-2.4.20-pre1/drivers/ide/ide-taskfile.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/ide/ide-taskfile.c	2002-08-12 11:47:56.000000000 +1000
@@ -10,7 +10,6 @@
  */
 
 #include <linux/config.h>
-#define __NO_VERSION__
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/string.h>
--- trivial-2.4.20-pre1/drivers/isdn/act2000/act2000_isa.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/act2000/act2000_isa.c	2002-08-12 11:47:56.000000000 +1000
@@ -12,7 +12,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include "act2000.h"
 #include "act2000_isa.h"
 #include "capi.h"
--- trivial-2.4.20-pre1/drivers/isdn/act2000/capi.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/act2000/capi.c	2002-08-12 11:47:56.000000000 +1000
@@ -13,7 +13,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include "act2000.h"
 #include "capi.h"
 
--- trivial-2.4.20-pre1/drivers/isdn/divert/divert_procfs.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/divert/divert_procfs.c	2002-08-12 11:47:56.000000000 +1000
@@ -10,7 +10,6 @@
  */
 
 #include <linux/config.h>
-#define __NO_VERSION__
 #include <linux/module.h>
 #include <linux/version.h>
 #include <linux/poll.h>
--- trivial-2.4.20-pre1/drivers/isdn/eicon/eicon_idi.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/eicon/eicon_idi.c	2002-08-12 11:47:56.000000000 +1000
@@ -17,7 +17,6 @@
  */
 
 #include <linux/config.h>
-#define __NO_VERSION__
 #include "eicon.h"
 #include "eicon_idi.h"
 #include "eicon_dsp.h"
--- trivial-2.4.20-pre1/drivers/isdn/eicon/linchr.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/eicon/linchr.c	2002-08-12 11:47:56.000000000 +1000
@@ -8,7 +8,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/module.h>
 
 #include <linux/kernel.h>
--- trivial-2.4.20-pre1/drivers/isdn/hisax/amd7930.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/amd7930.c	2002-08-12 11:47:56.000000000 +1000
@@ -90,7 +90,6 @@
  * 
  */
 
-#define __NO_VERSION__
 #include "hisax.h"
 #include "../../sbus/audio/amd7930.h"
 #include "isac.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/arcofi.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/arcofi.c	2002-08-12 11:47:56.000000000 +1000
@@ -10,7 +10,6 @@
  *
  */
  
-#define __NO_VERSION__
 #include "hisax.h"
 #include "isdnl1.h"
 #include "isac.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/asuscom.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/asuscom.c	2002-08-12 11:47:56.000000000 +1000
@@ -12,7 +12,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/init.h>
 #include "hisax.h"
 #include "isac.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/avm_a1.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/avm_a1.c	2002-08-12 11:47:56.000000000 +1000
@@ -10,7 +10,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/init.h>
 #include "hisax.h"
 #include "isac.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/avm_a1p.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/avm_a1p.c	2002-08-12 11:47:56.000000000 +1000
@@ -13,7 +13,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/init.h>
 #include "hisax.h"
 #include "isac.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/avm_pci.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/avm_pci.c	2002-08-12 11:47:56.000000000 +1000
@@ -12,7 +12,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/config.h>
 #include <linux/init.h>
 #include "hisax.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/bkm_a4t.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/bkm_a4t.c	2002-08-12 11:47:56.000000000 +1000
@@ -10,8 +10,6 @@
  *
  */
 
-#define __NO_VERSION__
-
 #include <linux/config.h>
 #include <linux/init.h>
 #include "hisax.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/bkm_a8.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/bkm_a8.c	2002-08-12 11:47:56.000000000 +1000
@@ -10,8 +10,6 @@
  *
  */
 
-#define __NO_VERSION__
-
 #include <linux/config.h>
 #include <linux/init.h>
 #include "hisax.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/callc.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/callc.c	2002-08-12 11:47:56.000000000 +1000
@@ -16,7 +16,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/module.h>
 #include <linux/init.h>
 #include "hisax.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/diva.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/diva.c	2002-08-12 11:47:56.000000000 +1000
@@ -15,7 +15,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/init.h>
 #include <linux/config.h>
 #include "hisax.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/elsa.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/elsa.c	2002-08-12 11:47:56.000000000 +1000
@@ -18,7 +18,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/init.h>
 #include <linux/config.h>
 #include "hisax.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/fsm.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/fsm.c	2002-08-12 11:47:56.000000000 +1000
@@ -14,7 +14,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/module.h>
 #include <linux/init.h>
 #include "hisax.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/gazel.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/gazel.c	2002-08-12 11:47:56.000000000 +1000
@@ -13,7 +13,6 @@
 
 #include <linux/config.h>
 #include <linux/init.h>
-#define __NO_VERSION__
 #include "hisax.h"
 #include "isac.h"
 #include "hscx.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/hfc_2bds0.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/hfc_2bds0.c	2002-08-12 11:47:56.000000000 +1000
@@ -10,7 +10,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/init.h>
 #include "hisax.h"
 #include "hfc_2bds0.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/hfc_2bs0.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/hfc_2bs0.c	2002-08-12 11:47:56.000000000 +1000
@@ -10,7 +10,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/init.h>
 #include "hisax.h"
 #include "hfc_2bs0.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/hfc_pci.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/hfc_pci.c	2002-08-12 11:47:56.000000000 +1000
@@ -17,7 +17,6 @@
 
 #include <linux/init.h>
 #include <linux/config.h>
-#define __NO_VERSION__
 #include "hisax.h"
 #include "hfc_pci.h"
 #include "isdnl1.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/hfc_sx.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/hfc_sx.c	2002-08-12 11:47:56.000000000 +1000
@@ -11,7 +11,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/init.h>
 #include "hisax.h"
 #include "hfc_sx.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/hfcscard.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/hfcscard.c	2002-08-12 11:47:56.000000000 +1000
@@ -10,7 +10,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/init.h>
 #include "hisax.h"
 #include "hfc_2bds0.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/hscx.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/hscx.c	2002-08-12 11:47:56.000000000 +1000
@@ -10,7 +10,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/init.h>
 #include "hisax.h"
 #include "hscx.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/icc.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/icc.c	2002-08-12 11:47:56.000000000 +1000
@@ -14,7 +14,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/init.h>
 #include "hisax.h"
 #include "icc.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/isac.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/isac.c	2002-08-12 11:47:56.000000000 +1000
@@ -13,7 +13,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include "hisax.h"
 #include "isac.h"
 #include "arcofi.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/isar.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/isar.c	2002-08-12 11:47:56.000000000 +1000
@@ -8,7 +8,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/init.h>
 #include "hisax.h"
 #include "isar.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/isdnl1.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/isdnl1.c	2002-08-12 11:47:56.000000000 +1000
@@ -20,7 +20,6 @@
 
 const char *l1_revision = "$Revision: 1.1.4.1 $";
 
-#define __NO_VERSION__
 #include <linux/init.h>
 #include "hisax.h"
 #include "isdnl1.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/isdnl2.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/isdnl2.c	2002-08-12 11:47:56.000000000 +1000
@@ -15,7 +15,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/init.h>
 #include "hisax.h"
 #include "isdnl2.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/isdnl3.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/isdnl3.c	2002-08-12 11:47:56.000000000 +1000
@@ -15,7 +15,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/init.h>
 #include "hisax.h"
 #include "isdnl3.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/isurf.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/isurf.c	2002-08-12 11:47:56.000000000 +1000
@@ -10,7 +10,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/init.h>
 #include "hisax.h"
 #include "isac.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/ix1_micro.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/ix1_micro.c	2002-08-12 11:47:56.000000000 +1000
@@ -17,7 +17,6 @@
  * Germany
  */
 
-#define __NO_VERSION__
 #include <linux/init.h>
 #include "hisax.h"
 #include "isac.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/jade.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/jade.c	2002-08-12 11:47:56.000000000 +1000
@@ -11,7 +11,6 @@
  */
 
 
-#define __NO_VERSION__
 #include <linux/init.h>
 #include "hisax.h"
 #include "hscx.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/l3_1tr6.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/l3_1tr6.c	2002-08-12 11:47:56.000000000 +1000
@@ -13,7 +13,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include "hisax.h"
 #include "l3_1tr6.h"
 #include "isdnl3.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/l3dss1.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/l3dss1.c	2002-08-12 11:47:56.000000000 +1000
@@ -19,7 +19,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include "hisax.h"
 #include "isdnl3.h"
 #include "l3dss1.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/l3ni1.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/l3ni1.c	2002-08-12 11:47:56.000000000 +1000
@@ -18,7 +18,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include "hisax.h"
 #include "isdnl3.h"
 #include "l3ni1.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/lmgr.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/lmgr.c	2002-08-12 11:47:56.000000000 +1000
@@ -10,7 +10,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include "hisax.h"
 
 static void
--- trivial-2.4.20-pre1/drivers/isdn/hisax/mic.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/mic.c	2002-08-12 11:47:56.000000000 +1000
@@ -10,7 +10,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/init.h>
 #include "hisax.h"
 #include "isac.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/netjet.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/netjet.c	2002-08-12 11:47:56.000000000 +1000
@@ -12,7 +12,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/init.h>
 #include "hisax.h"
 #include "isac.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/niccy.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/niccy.c	2002-08-12 11:47:56.000000000 +1000
@@ -14,7 +14,6 @@
  */
 
 
-#define __NO_VERSION__
 #include <linux/config.h>
 #include <linux/init.h>
 #include "hisax.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/nj_s.c.orig	2002-08-12 11:47:51.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/nj_s.c	2002-08-12 11:47:56.000000000 +1000
@@ -5,7 +5,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/config.h>
 #include <linux/init.h>
 #include "hisax.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/nj_u.c.orig	2002-08-12 11:47:52.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/nj_u.c	2002-08-12 11:47:56.000000000 +1000
@@ -5,7 +5,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/config.h>
 #include <linux/init.h>
 #include "hisax.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/q931.c.orig	2002-08-12 11:47:52.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/q931.c	2002-08-12 11:47:56.000000000 +1000
@@ -17,7 +17,6 @@
  */
 
 
-#define __NO_VERSION__
 #include "hisax.h"
 #include "l3_1tr6.h"
 
--- trivial-2.4.20-pre1/drivers/isdn/hisax/s0box.c.orig	2002-08-12 11:47:52.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/s0box.c	2002-08-12 11:47:56.000000000 +1000
@@ -10,7 +10,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/init.h>
 #include "hisax.h"
 #include "isac.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/saphir.c.orig	2002-08-12 11:47:52.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/saphir.c	2002-08-12 11:47:56.000000000 +1000
@@ -12,7 +12,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/init.h>
 #include "hisax.h"
 #include "isac.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/sedlbauer.c.orig	2002-08-12 11:47:52.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/sedlbauer.c	2002-08-12 11:47:56.000000000 +1000
@@ -38,7 +38,6 @@
  * For example: hisaxctrl <DriverID> 9 ISAR.BIN
 */
 
-#define __NO_VERSION__
 #include <linux/init.h>
 #include <linux/config.h>
 #include "hisax.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/sportster.c.orig	2002-08-12 11:47:52.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/sportster.c	2002-08-12 11:47:56.000000000 +1000
@@ -12,7 +12,6 @@
  *
  *
  */
-#define __NO_VERSION__
 #include <linux/init.h>
 #include "hisax.h"
 #include "isac.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/tei.c.orig	2002-08-12 11:47:52.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/tei.c	2002-08-12 11:47:56.000000000 +1000
@@ -15,7 +15,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include "hisax.h"
 #include "isdnl2.h"
 #include <linux/init.h>
--- trivial-2.4.20-pre1/drivers/isdn/hisax/teleint.c.orig	2002-08-12 11:47:52.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/teleint.c	2002-08-12 11:47:56.000000000 +1000
@@ -10,7 +10,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/init.h>
 #include "hisax.h"
 #include "isac.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/teles0.c.orig	2002-08-12 11:47:52.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/teles0.c	2002-08-12 11:47:56.000000000 +1000
@@ -15,7 +15,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/init.h>
 #include "hisax.h"
 #include "isdnl1.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/teles3.c.orig	2002-08-12 11:47:52.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/teles3.c	2002-08-12 11:47:56.000000000 +1000
@@ -13,7 +13,6 @@
  *              Beat Doebeli
  *
  */
-#define __NO_VERSION__
 #include <linux/init.h>
 #include "hisax.h"
 #include "isac.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/telespci.c.orig	2002-08-12 11:47:52.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/telespci.c	2002-08-12 11:47:56.000000000 +1000
@@ -12,7 +12,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/init.h>
 #include <linux/config.h>
 #include "hisax.h"
--- trivial-2.4.20-pre1/drivers/isdn/hisax/w6692.c.orig	2002-08-12 11:47:52.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hisax/w6692.c	2002-08-12 11:47:56.000000000 +1000
@@ -12,7 +12,6 @@
 
 #include <linux/config.h>
 #include <linux/init.h>
-#define __NO_VERSION__
 #include "hisax.h"
 #include "w6692.h"
 #include "isdnl1.h"
--- trivial-2.4.20-pre1/drivers/isdn/hysdn/hysdn_net.c.orig	2002-08-12 11:47:52.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hysdn/hysdn_net.c	2002-08-12 11:47:56.000000000 +1000
@@ -13,7 +13,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/module.h>
 #include <linux/version.h>
 #include <linux/signal.h>
--- trivial-2.4.20-pre1/drivers/isdn/hysdn/hysdn_procconf.c.orig	2002-08-12 11:47:52.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hysdn/hysdn_procconf.c	2002-08-12 11:47:56.000000000 +1000
@@ -11,7 +11,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/module.h>
 #include <linux/version.h>
 #include <linux/poll.h>
--- trivial-2.4.20-pre1/drivers/isdn/hysdn/hysdn_proclog.c.orig	2002-08-12 11:47:52.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/hysdn/hysdn_proclog.c	2002-08-12 11:47:56.000000000 +1000
@@ -10,7 +10,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/module.h>
 #include <linux/version.h>
 #include <linux/poll.h>
--- trivial-2.4.20-pre1/drivers/isdn/pcbit/drv.c.orig	2002-08-12 11:47:52.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/pcbit/drv.c	2002-08-12 11:47:56.000000000 +1000
@@ -17,8 +17,6 @@
  *		
  */
 
-#define __NO_VERSION__
-
 #include <linux/module.h>
 
 #include <linux/sched.h>
--- trivial-2.4.20-pre1/drivers/isdn/sc/command.c.orig	2002-08-12 11:47:52.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/sc/command.c	2002-08-12 11:47:56.000000000 +1000
@@ -15,7 +15,6 @@
  *     +1 (416) 297-6433 Facsimile
  */
 
-#define __NO_VERSION__
 #include <linux/module.h>
 #include "includes.h"		/* This must be first */
 #include "hardware.h"
--- trivial-2.4.20-pre1/drivers/isdn/sc/event.c.orig	2002-08-12 11:47:52.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/sc/event.c	2002-08-12 11:47:56.000000000 +1000
@@ -15,7 +15,6 @@
  *     +1 (416) 297-6433 Facsimile
  */
 
-#define __NO_VERSION__
 #include "includes.h"
 #include "hardware.h"
 #include "message.h"
--- trivial-2.4.20-pre1/drivers/isdn/sc/interrupt.c.orig	2002-08-12 11:47:52.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/sc/interrupt.c	2002-08-12 11:47:56.000000000 +1000
@@ -15,7 +15,6 @@
  *     +1 (416) 297-6433 Facsimile
  */
 
-#define __NO_VERSION__
 #include "includes.h"
 #include "hardware.h"
 #include "message.h"
--- trivial-2.4.20-pre1/drivers/isdn/sc/ioctl.c.orig	2002-08-12 11:47:52.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/sc/ioctl.c	2002-08-12 11:47:56.000000000 +1000
@@ -6,7 +6,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include "includes.h"
 #include "hardware.h"
 #include "message.h"
--- trivial-2.4.20-pre1/drivers/isdn/sc/message.c.orig	2002-08-12 11:47:52.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/sc/message.c	2002-08-12 11:47:56.000000000 +1000
@@ -17,7 +17,6 @@
  *     +1 (416) 297-6433 Facsimile
  */
 
-#define __NO_VERSION__
 #include "includes.h"
 #include "hardware.h"
 #include "message.h"
--- trivial-2.4.20-pre1/drivers/isdn/sc/packet.c.orig	2002-08-12 11:47:52.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/sc/packet.c	2002-08-12 11:47:56.000000000 +1000
@@ -15,7 +15,6 @@
  *     +1 (416) 297-6433 Facsimile
  */
 
-#define __NO_VERSION__
 #include "includes.h"
 #include "hardware.h"
 #include "message.h"
--- trivial-2.4.20-pre1/drivers/isdn/sc/shmem.c.orig	2002-08-12 11:47:52.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/sc/shmem.c	2002-08-12 11:47:56.000000000 +1000
@@ -17,7 +17,6 @@
  *     +1 (416) 297-6433 Facsimile
  */
 
-#define __NO_VERSION__
 #include "includes.h"		/* This must be first */
 #include "hardware.h"
 #include "card.h"
--- trivial-2.4.20-pre1/drivers/isdn/sc/timer.c.orig	2002-08-12 11:47:52.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/isdn/sc/timer.c	2002-08-12 11:47:56.000000000 +1000
@@ -15,7 +15,6 @@
  *     +1 (416) 297-6433 Facsimile
  */
 
-#define __NO_VERSION__
 #include "includes.h"
 #include "hardware.h"
 #include "message.h"
--- trivial-2.4.20-pre1/drivers/media/radio/miropcm20-rds-core.c.orig	2002-08-12 11:47:52.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/media/radio/miropcm20-rds-core.c	2002-08-12 11:47:56.000000000 +1000
@@ -13,8 +13,6 @@
  *        RDS support for MiroSound PCM20 radio
  */
 
-#define _NO_VERSION_
-
 /* #include <linux/kernel.h> */
 #include <linux/module.h>
 #include <linux/init.h>
--- trivial-2.4.20-pre1/drivers/media/video/bttv-cards.c.orig	2002-08-12 11:47:52.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/media/video/bttv-cards.c	2002-08-12 11:47:56.000000000 +1000
@@ -24,8 +24,6 @@
     
 */
 
-#define __NO_VERSION__ 1
-
 #include <linux/version.h>
 #include <linux/delay.h>
 #include <linux/module.h>
--- trivial-2.4.20-pre1/drivers/media/video/bttv-if.c.orig	2002-08-12 11:47:52.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/media/video/bttv-if.c	2002-08-12 11:47:56.000000000 +1000
@@ -25,8 +25,6 @@
     
 */
 
-#define __NO_VERSION__ 1
-
 #include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
--- trivial-2.4.20-pre1/drivers/mtd/nftlmount.c.orig	2002-08-12 11:47:52.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/mtd/nftlmount.c	2002-08-12 11:47:56.000000000 +1000
@@ -21,7 +21,6 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
-#define __NO_VERSION__
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <asm/errno.h>
--- trivial-2.4.20-pre1/drivers/pcmcia/bulkmem.c.orig	2002-08-12 11:47:52.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/pcmcia/bulkmem.c	2002-08-12 11:47:56.000000000 +1000
@@ -31,8 +31,6 @@
     
 ======================================================================*/
 
-#define __NO_VERSION__
-
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
--- trivial-2.4.20-pre1/drivers/pcmcia/cardbus.c.orig	2002-08-12 11:47:52.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/pcmcia/cardbus.c	2002-08-12 11:47:56.000000000 +1000
@@ -45,9 +45,6 @@
  *		Linus, Jan 2000
  */
 
-
-#define __NO_VERSION__
-
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
--- trivial-2.4.20-pre1/drivers/pcmcia/cistpl.c.orig	2002-08-12 11:47:52.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/pcmcia/cistpl.c	2002-08-12 11:47:56.000000000 +1000
@@ -31,8 +31,6 @@
     
 ======================================================================*/
 
-#define __NO_VERSION__
-
 #include <linux/config.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
--- trivial-2.4.20-pre1/drivers/pcmcia/rsrc_mgr.c.orig	2002-08-12 11:47:52.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/pcmcia/rsrc_mgr.c	2002-08-12 11:47:56.000000000 +1000
@@ -31,8 +31,6 @@
     
 ======================================================================*/
 
-#define __NO_VERSION__
-
 #include <linux/config.h>
 #include <linux/module.h>
 #include <linux/init.h>
--- trivial-2.4.20-pre1/drivers/pnp/isapnp_proc.c.orig	2002-08-12 11:47:53.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/pnp/isapnp_proc.c	2002-08-12 11:47:56.000000000 +1000
@@ -19,8 +19,6 @@
  *
  */
 
-#define __NO_VERSION__
-
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
--- trivial-2.4.20-pre1/drivers/s390/block/xpram.c.orig	2002-08-12 11:47:53.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/s390/block/xpram.c	2002-08-12 11:47:56.000000000 +1000
@@ -52,7 +52,6 @@
 #  ifndef __KERNEL__
 #    define __KERNEL__
 #  endif
-#  define __NO_VERSION__ /* don't define kernel_version in module.h */
 #endif /* MODULE */
 
 #include <linux/module.h>
--- trivial-2.4.20-pre1/drivers/s390/char/tapeblock.c.orig	2002-08-12 11:47:53.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/s390/char/tapeblock.c	2002-08-12 11:47:56.000000000 +1000
@@ -24,7 +24,6 @@
 #include <asm/s390dyn.h>
 #include <linux/compatmac.h>
 #ifdef MODULE
-#define __NO_VERSION__
 #include <linux/module.h>
 #endif
 #include "tape.h"
--- trivial-2.4.20-pre1/drivers/s390/char/tapechar.c.orig	2002-08-12 11:47:53.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/s390/char/tapechar.c	2002-08-12 11:47:56.000000000 +1000
@@ -25,7 +25,6 @@
 #include <asm/uaccess.h>
 #include <linux/compatmac.h>
 #ifdef MODULE
-#define __NO_VERSION__
 #include <linux/module.h>
 #endif
 #include "tape.h"
--- trivial-2.4.20-pre1/drivers/s390/net/ctctty.c.orig	2002-08-12 11:47:53.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/s390/net/ctctty.c	2002-08-12 11:47:56.000000000 +1000
@@ -22,7 +22,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/config.h>
 #include <linux/module.h>
 #include <linux/tty.h>
--- trivial-2.4.20-pre1/drivers/scsi/aic7xxx/aic7xxx_osm.h.orig	2002-08-12 11:47:53.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/scsi/aic7xxx/aic7xxx_osm.h	2002-08-12 11:47:56.000000000 +1000
@@ -69,7 +69,6 @@
 #include <linux/pci.h>
 #include <linux/version.h>
 #ifndef AHC_MODVERSION_FILE
-#define __NO_VERSION__
 #endif
 #include <linux/module.h>
 #include <asm/byteorder.h>
--- trivial-2.4.20-pre1/drivers/scsi/constants.c.orig	2002-08-12 11:47:53.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/scsi/constants.c	2002-08-12 11:47:56.000000000 +1000
@@ -5,7 +5,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/module.h>
 
 #include <linux/config.h>
--- trivial-2.4.20-pre1/drivers/scsi/hosts.c.orig	2002-08-12 11:47:53.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/scsi/hosts.c	2002-08-12 11:47:56.000000000 +1000
@@ -24,7 +24,6 @@
  *  hosts currently present in the system.
  */
 
-#define __NO_VERSION__
 #include <linux/module.h>
 #include <linux/blk.h>
 #include <linux/kernel.h>
--- trivial-2.4.20-pre1/drivers/scsi/pcmcia/Makefile.orig	2002-08-12 11:47:53.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/scsi/pcmcia/Makefile	2002-08-12 11:47:56.000000000 +1000
@@ -11,9 +11,9 @@
 
 vpath %c ..
 
-CFLAGS_aha152x.o = -DPCMCIA -D__NO_VERSION__ -DAHA152X_STAT
-CFLAGS_fdomain.o = -DPCMCIA -D__NO_VERSION__
-CFLAGS_qlogicfas.o = -DPCMCIA -D__NO_VERSION__
+CFLAGS_aha152x.o = -DPCMCIA -DAHA152X_STAT
+CFLAGS_fdomain.o = -DPCMCIA
+CFLAGS_qlogicfas.o = -DPCMCIA
 
 # 16-bit client drivers
 obj-$(CONFIG_PCMCIA_QLOGIC)	+= qlogic_cs.o
--- trivial-2.4.20-pre1/drivers/scsi/scsi_dma.c.orig	2002-08-12 11:47:53.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/scsi/scsi_dma.c	2002-08-12 11:47:56.000000000 +1000
@@ -5,7 +5,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/config.h>
 #include <linux/module.h>
 #include <linux/blk.h>
--- trivial-2.4.20-pre1/drivers/scsi/scsi_error.c.orig	2002-08-12 11:47:53.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/scsi/scsi_error.c	2002-08-12 11:47:56.000000000 +1000
@@ -8,7 +8,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/module.h>
 
 #include <linux/sched.h>
--- trivial-2.4.20-pre1/drivers/scsi/scsi_ioctl.c.orig	2002-08-12 11:47:53.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/scsi/scsi_ioctl.c	2002-08-12 11:47:56.000000000 +1000
@@ -4,7 +4,6 @@
  * - get rid of some verify_areas and use __copy*user and __get/put_user
  *   for the ones that remain
  */
-#define __NO_VERSION__
 #include <linux/module.h>
 
 #include <asm/io.h>
--- trivial-2.4.20-pre1/drivers/scsi/scsi_lib.c.orig	2002-08-12 11:47:53.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/scsi/scsi_lib.c	2002-08-12 11:47:56.000000000 +1000
@@ -17,7 +17,6 @@
  * go through and retrofit queueing functions into all 30 some-odd drivers.
  */
 
-#define __NO_VERSION__
 #include <linux/module.h>
 
 #include <linux/sched.h>
--- trivial-2.4.20-pre1/drivers/scsi/scsi_merge.c.orig	2002-08-12 11:47:53.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/scsi/scsi_merge.c	2002-08-12 11:47:56.000000000 +1000
@@ -32,7 +32,6 @@
  * in queue management.
  */
 
-#define __NO_VERSION__
 #include <linux/config.h>
 #include <linux/module.h>
 
--- trivial-2.4.20-pre1/drivers/scsi/scsi_obsolete.c.orig	2002-08-12 11:47:53.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/scsi/scsi_obsolete.c	2002-08-12 11:47:56.000000000 +1000
@@ -46,7 +46,6 @@
  * driver uses the new code this *ENTIRE* file will be nuked.
  */
 
-#define __NO_VERSION__
 #include <linux/module.h>
 
 #include <linux/sched.h>
--- trivial-2.4.20-pre1/drivers/scsi/scsi_proc.c.orig	2002-08-12 11:47:53.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/scsi/scsi_proc.c	2002-08-12 11:47:56.000000000 +1000
@@ -17,7 +17,6 @@
  */
 
 #include <linux/config.h>	/* for CONFIG_PROC_FS */
-#define __NO_VERSION__
 #include <linux/module.h>
 
 #include <linux/string.h>
--- trivial-2.4.20-pre1/drivers/scsi/scsi_queue.c.orig	2002-08-12 11:47:53.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/scsi/scsi_queue.c	2002-08-12 11:47:56.000000000 +1000
@@ -10,7 +10,6 @@
  *  we attempt to remove commands from the queue and retry them.
  */
 
-#define __NO_VERSION__
 #include <linux/module.h>
 
 #include <linux/sched.h>
--- trivial-2.4.20-pre1/drivers/scsi/scsi_scan.c.orig	2002-08-12 11:47:53.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/scsi/scsi_scan.c	2002-08-12 11:47:56.000000000 +1000
@@ -8,7 +8,6 @@
  *  clearer.
  */
 
-#define __NO_VERSION__
 #include <linux/config.h>
 #include <linux/module.h>
 #include <linux/init.h>
--- trivial-2.4.20-pre1/drivers/scsi/scsi_syms.c.orig	2002-08-12 11:47:53.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/scsi/scsi_syms.c	2002-08-12 11:47:56.000000000 +1000
@@ -2,7 +2,6 @@
  * We should not even be trying to compile this if we are not doing
  * a module.
  */
-#define __NO_VERSION__
 #include <linux/config.h>
 #include <linux/module.h>
 
--- trivial-2.4.20-pre1/drivers/scsi/scsicam.c.orig	2002-08-12 11:47:53.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/scsi/scsicam.c	2002-08-12 11:47:56.000000000 +1000
@@ -10,7 +10,6 @@
  * For more information, please consult the SCSI-CAM draft.
  */
 
-#define __NO_VERSION__
 #include <linux/module.h>
 
 #include <linux/fs.h>
--- trivial-2.4.20-pre1/drivers/sound/audio_syms.c.orig	2002-08-12 11:47:54.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/sound/audio_syms.c	2002-08-12 11:47:56.000000000 +1000
@@ -1,9 +1,7 @@
 /*
  * Exported symbols for audio driver.
- * __NO_VERSION__ because this is still part of sound.o.
  */
 
-#define __NO_VERSION__
 #include <linux/module.h>
 
 char audio_syms_symbol;
--- trivial-2.4.20-pre1/drivers/sound/emu10k1/audio.c.orig	2002-08-12 11:47:54.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/sound/emu10k1/audio.c	2002-08-12 11:47:56.000000000 +1000
@@ -30,7 +30,6 @@
  **********************************************************************
  */
 
-#define __NO_VERSION__
 #include <linux/module.h>
 #include <linux/poll.h>
 #include <linux/slab.h>
--- trivial-2.4.20-pre1/drivers/sound/emu10k1/midi.c.orig	2002-08-12 11:47:54.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/sound/emu10k1/midi.c	2002-08-12 11:47:56.000000000 +1000
@@ -29,7 +29,6 @@
  **********************************************************************
  */
 
-#define __NO_VERSION__
 #include <linux/module.h>
 #include <linux/poll.h>
 #include <linux/slab.h>
--- trivial-2.4.20-pre1/drivers/sound/emu10k1/mixer.c.orig	2002-08-12 11:47:54.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/sound/emu10k1/mixer.c	2002-08-12 11:47:56.000000000 +1000
@@ -30,7 +30,6 @@
  **********************************************************************
  */
 
-#define __NO_VERSION__		/* Kernel version only defined once */
 #include <linux/module.h>
 #include <linux/version.h>
 #include <asm/uaccess.h>
--- trivial-2.4.20-pre1/drivers/sound/emu10k1/passthrough.c.orig	2002-08-12 11:47:54.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/sound/emu10k1/passthrough.c	2002-08-12 11:47:56.000000000 +1000
@@ -29,7 +29,6 @@
  **********************************************************************
  */
                        
-#define __NO_VERSION__
 #include <linux/module.h>
 #include <linux/poll.h>
 #include <linux/slab.h>
--- trivial-2.4.20-pre1/drivers/sound/midi_syms.c.orig	2002-08-12 11:47:54.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/sound/midi_syms.c	2002-08-12 11:47:56.000000000 +1000
@@ -1,9 +1,7 @@
 /*
  * Exported symbols for midi driver.
- * __NO_VERSION__ because this is still part of sound.o.
  */
 
-#define __NO_VERSION__
 #include <linux/module.h>
 
 char midi_syms_symbol;
--- trivial-2.4.20-pre1/drivers/sound/nm256_audio.c.orig	2002-08-12 11:47:54.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/sound/nm256_audio.c	2002-08-12 11:47:56.000000000 +1000
@@ -19,7 +19,6 @@
  *		Ported to 2.4 PCI API.
  */
 
-#define __NO_VERSION__
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/module.h>
--- trivial-2.4.20-pre1/drivers/sound/sequencer_syms.c.orig	2002-08-12 11:47:54.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/sound/sequencer_syms.c	2002-08-12 11:47:56.000000000 +1000
@@ -1,9 +1,7 @@
 /*
  * Exported symbols for sequencer driver.
- * __NO_VERSION__ because this is still part of sound.o.
  */
 
-#define __NO_VERSION__
 #include <linux/module.h>
 
 char sequencer_syms_symbol;
--- trivial-2.4.20-pre1/drivers/usb/inode.c.orig	2002-08-12 11:47:54.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/usb/inode.c	2002-08-12 11:47:56.000000000 +1000
@@ -28,7 +28,6 @@
 
 /*****************************************************************************/
 
-#define __NO_VERSION__
 #include <linux/config.h>
 #include <linux/module.h>
 #include <linux/fs.h>
--- trivial-2.4.20-pre1/drivers/usb/usbvideo.c.orig	2002-08-12 11:47:54.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/usb/usbvideo.c	2002-08-12 11:47:56.000000000 +1000
@@ -18,7 +18,6 @@
 #include <linux/sched.h>
 #include <linux/list.h>
 #include <linux/slab.h>
-#define	__NO_VERSION__		/* Temporary: usbvideo is not a module yet */
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/smp_lock.h>
--- trivial-2.4.20-pre1/fs/autofs/inode.c.orig	2002-08-12 11:47:54.000000000 +1000
+++ trivial-2.4.20-pre1/fs/autofs/inode.c	2002-08-12 11:47:56.000000000 +1000
@@ -16,7 +16,6 @@
 #include <linux/locks.h>
 #include <asm/bitops.h>
 #include "autofs_i.h"
-#define __NO_VERSION__
 #include <linux/module.h>
 
 static void autofs_put_super(struct super_block *sb)
--- trivial-2.4.20-pre1/fs/autofs4/inode.c.orig	2002-08-12 11:47:54.000000000 +1000
+++ trivial-2.4.20-pre1/fs/autofs4/inode.c	2002-08-12 11:47:56.000000000 +1000
@@ -16,7 +16,6 @@
 #include <linux/locks.h>
 #include <asm/bitops.h>
 #include "autofs_i.h"
-#define __NO_VERSION__
 #include <linux/module.h>
 
 static void ino_lnkfree(struct autofs_info *ino)
--- trivial-2.4.20-pre1/fs/coda/inode.c.orig	2002-08-12 11:47:54.000000000 +1000
+++ trivial-2.4.20-pre1/fs/coda/inode.c	2002-08-12 11:47:56.000000000 +1000
@@ -8,7 +8,6 @@
  * Copyright (C) Carnegie Mellon University
  */
 
-#define __NO_VERSION__
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
--- trivial-2.4.20-pre1/fs/coda/pioctl.c.orig	2002-08-12 11:47:54.000000000 +1000
+++ trivial-2.4.20-pre1/fs/coda/pioctl.c	2002-08-12 11:47:56.000000000 +1000
@@ -15,7 +15,6 @@
 #include <linux/errno.h>
 #include <linux/locks.h>
 #include <linux/string.h>
-#define __NO_VERSION__
 #include <linux/module.h>
 #include <asm/uaccess.h>
 
--- trivial-2.4.20-pre1/fs/coda/sysctl.c.orig	2002-08-12 11:47:54.000000000 +1000
+++ trivial-2.4.20-pre1/fs/coda/sysctl.c	2002-08-12 11:47:56.000000000 +1000
@@ -23,7 +23,6 @@
 #include <asm/bitops.h>
 #include <asm/uaccess.h>
 #include <linux/utsname.h>
-#define __NO_VERSION__
 #include <linux/module.h>
 
 #include <linux/coda.h>
--- trivial-2.4.20-pre1/fs/exec.c.orig	2002-08-12 11:47:54.000000000 +1000
+++ trivial-2.4.20-pre1/fs/exec.c	2002-08-12 11:47:56.000000000 +1000
@@ -35,7 +35,6 @@
 #include <linux/highmem.h>
 #include <linux/spinlock.h>
 #include <linux/personality.h>
-#define __NO_VERSION__
 #include <linux/module.h>
 
 #include <asm/uaccess.h>
--- trivial-2.4.20-pre1/fs/intermezzo/cache.c.orig	2002-08-12 11:47:54.000000000 +1000
+++ trivial-2.4.20-pre1/fs/intermezzo/cache.c	2002-08-12 11:47:56.000000000 +1000
@@ -7,7 +7,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/module.h>
 #include <stdarg.h>
 #include <asm/bitops.h>
--- trivial-2.4.20-pre1/fs/intermezzo/dcache.c.orig	2002-08-12 11:47:54.000000000 +1000
+++ trivial-2.4.20-pre1/fs/intermezzo/dcache.c	2002-08-12 11:47:56.000000000 +1000
@@ -7,7 +7,6 @@
  * the InterMezzo project. Contact Peter Braam (coda@stelias.com).
  */
 
-#define __NO_VERSION__
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
--- trivial-2.4.20-pre1/fs/intermezzo/dir.c.orig	2002-08-12 11:47:54.000000000 +1000
+++ trivial-2.4.20-pre1/fs/intermezzo/dir.c	2002-08-12 11:47:56.000000000 +1000
@@ -27,7 +27,6 @@
 #include <linux/locks.h>
 #include <linux/blkdev.h>
 #include <linux/init.h>
-#define __NO_VERSION__
 #include <linux/module.h>
 
 #include <linux/intermezzo_fs.h>
--- trivial-2.4.20-pre1/fs/intermezzo/ext_attr.c.orig	2002-08-12 11:47:54.000000000 +1000
+++ trivial-2.4.20-pre1/fs/intermezzo/ext_attr.c	2002-08-12 11:47:56.000000000 +1000
@@ -7,7 +7,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
--- trivial-2.4.20-pre1/fs/intermezzo/file.c.orig	2002-08-12 11:47:54.000000000 +1000
+++ trivial-2.4.20-pre1/fs/intermezzo/file.c	2002-08-12 11:47:56.000000000 +1000
@@ -35,7 +35,6 @@
 #include <linux/blkdev.h>
 #include <linux/init.h>
 #include <linux/smp_lock.h>
-#define __NO_VERSION__
 #include <linux/module.h>
 
 #include <linux/intermezzo_fs.h>
--- trivial-2.4.20-pre1/fs/intermezzo/inode.c.orig	2002-08-12 11:47:54.000000000 +1000
+++ trivial-2.4.20-pre1/fs/intermezzo/inode.c	2002-08-12 11:47:56.000000000 +1000
@@ -8,7 +8,6 @@
  * Copyright (C) Carnegie Mellon University
  */
 
-#define __NO_VERSION__
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
--- trivial-2.4.20-pre1/fs/intermezzo/kml.c.orig	2002-08-12 11:47:54.000000000 +1000
+++ trivial-2.4.20-pre1/fs/intermezzo/kml.c	2002-08-12 11:47:56.000000000 +1000
@@ -1,7 +1,6 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
-#define __NO_VERSION__
 #include <linux/module.h>
 #include <asm/uaccess.h>
 
--- trivial-2.4.20-pre1/fs/intermezzo/kml_decode.c.orig	2002-08-12 11:47:55.000000000 +1000
+++ trivial-2.4.20-pre1/fs/intermezzo/kml_decode.c	2002-08-12 11:47:56.000000000 +1000
@@ -5,7 +5,6 @@
  *
  * Copyright (C) 2001 Mountainview Data, Inc.
  */
-#define __NO_VERSION__
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
--- trivial-2.4.20-pre1/fs/intermezzo/kml_reint.c.orig	2002-08-12 11:47:55.000000000 +1000
+++ trivial-2.4.20-pre1/fs/intermezzo/kml_reint.c	2002-08-12 11:47:56.000000000 +1000
@@ -6,7 +6,6 @@
  * Copyright (C) 2000 Mountainview Data, Inc.
  */
 
-#define __NO_VERSION__
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
--- trivial-2.4.20-pre1/fs/intermezzo/kml_setup.c.orig	2002-08-12 11:47:55.000000000 +1000
+++ trivial-2.4.20-pre1/fs/intermezzo/kml_setup.c	2002-08-12 11:47:56.000000000 +1000
@@ -1,7 +1,6 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
-#define __NO_VERSION__
 #include <linux/module.h>
 #include <asm/uaccess.h>
 
--- trivial-2.4.20-pre1/fs/intermezzo/methods.c.orig	2002-08-12 11:47:55.000000000 +1000
+++ trivial-2.4.20-pre1/fs/intermezzo/methods.c	2002-08-12 11:47:56.000000000 +1000
@@ -26,7 +26,6 @@
 #include <linux/locks.h>
 #include <linux/blkdev.h>
 #include <linux/init.h>
-#define __NO_VERSION__
 #include <linux/module.h>
 
 #include <linux/fsfilter.h>
--- trivial-2.4.20-pre1/fs/intermezzo/super.c.orig	2002-08-12 11:47:55.000000000 +1000
+++ trivial-2.4.20-pre1/fs/intermezzo/super.c	2002-08-12 11:47:56.000000000 +1000
@@ -26,7 +26,6 @@
 #include <linux/locks.h>
 #include <linux/blkdev.h>
 #include <linux/init.h>
-#define __NO_VERSION__
 #include <linux/module.h>
 
 #include <linux/intermezzo_fs.h>
--- trivial-2.4.20-pre1/fs/intermezzo/sysctl.c.orig	2002-08-12 11:47:55.000000000 +1000
+++ trivial-2.4.20-pre1/fs/intermezzo/sysctl.c	2002-08-12 11:47:56.000000000 +1000
@@ -2,7 +2,6 @@
  *  Sysctrl entries for Intermezzo!
  */
 
-#define __NO_VERSION__
 #include <linux/config.h> /* for CONFIG_PROC_FS */
 #include <linux/module.h>
 #include <linux/sched.h>
--- trivial-2.4.20-pre1/fs/jffs/intrep.c.orig	2002-08-12 11:47:55.000000000 +1000
+++ trivial-2.4.20-pre1/fs/jffs/intrep.c	2002-08-12 11:47:56.000000000 +1000
@@ -55,7 +55,6 @@
  *
  */
 
-#define __NO_VERSION__
 #include <linux/config.h>
 #include <linux/types.h>
 #include <linux/slab.h>
--- trivial-2.4.20-pre1/fs/jffs/jffs_fm.c.orig	2002-08-12 11:47:55.000000000 +1000
+++ trivial-2.4.20-pre1/fs/jffs/jffs_fm.c	2002-08-12 11:47:56.000000000 +1000
@@ -16,7 +16,6 @@
  * Copyright (C) 2000  Alexander Larsson (alex@cendio.se), Cendio Systems AB
  *
  */
-#define __NO_VERSION__
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/jffs.h>
--- trivial-2.4.20-pre1/fs/lockd/lockd_syms.c.orig	2002-08-12 11:47:55.000000000 +1000
+++ trivial-2.4.20-pre1/fs/lockd/lockd_syms.c	2002-08-12 11:47:56.000000000 +1000
@@ -8,7 +8,6 @@
  * Copyright (C) 1997 Olaf Kirch <okir@monad.swb.de>
  */
 
-#define __NO_VERSION__
 #include <linux/config.h>
 #include <linux/module.h>
 
--- trivial-2.4.20-pre1/fs/msdos/namei.c.orig	2002-08-12 11:47:55.000000000 +1000
+++ trivial-2.4.20-pre1/fs/msdos/namei.c	2002-08-12 11:47:56.000000000 +1000
@@ -7,7 +7,6 @@
  */
 
 
-#define __NO_VERSION__
 #include <linux/module.h>
 
 #include <linux/sched.h>
--- trivial-2.4.20-pre1/fs/nfsd/nfssvc.c.orig	2002-08-12 11:47:55.000000000 +1000
+++ trivial-2.4.20-pre1/fs/nfsd/nfssvc.c	2002-08-12 11:47:56.000000000 +1000
@@ -8,7 +8,6 @@
  * Copyright (C) 1995, 1996, 1997 Olaf Kirch <okir@monad.swb.de>
  */
 
-#define __NO_VERSION__
 #include <linux/config.h>
 #include <linux/module.h>
 
--- trivial-2.4.20-pre1/fs/nfsd/stats.c.orig	2002-08-12 11:47:55.000000000 +1000
+++ trivial-2.4.20-pre1/fs/nfsd/stats.c	2002-08-12 11:47:56.000000000 +1000
@@ -27,7 +27,6 @@
 #include <linux/sched.h>
 #include <linux/proc_fs.h>
 #include <linux/stat.h>
-#define __NO_VERSION__
 #include <linux/module.h>
 
 #include <linux/sunrpc/svc.h>
--- trivial-2.4.20-pre1/fs/nfsd/vfs.c.orig	2002-08-12 11:47:55.000000000 +1000
+++ trivial-2.4.20-pre1/fs/nfsd/vfs.c	2002-08-12 11:47:56.000000000 +1000
@@ -31,7 +31,6 @@
 #include <linux/unistd.h>
 #include <linux/slab.h>
 #include <linux/in.h>
-#define __NO_VERSION__
 #include <linux/module.h>
 
 #include <linux/sunrpc/svc.h>
--- trivial-2.4.20-pre1/fs/proc/generic.c.orig	2002-08-12 11:47:55.000000000 +1000
+++ trivial-2.4.20-pre1/fs/proc/generic.c	2002-08-12 11:47:56.000000000 +1000
@@ -14,7 +14,6 @@
 #include <linux/sched.h>
 #include <linux/proc_fs.h>
 #include <linux/stat.h>
-#define __NO_VERSION__
 #include <linux/module.h>
 #include <asm/bitops.h>
 
--- trivial-2.4.20-pre1/fs/proc/inode.c.orig	2002-08-12 11:47:55.000000000 +1000
+++ trivial-2.4.20-pre1/fs/proc/inode.c	2002-08-12 11:47:56.000000000 +1000
@@ -13,7 +13,6 @@
 #include <linux/file.h>
 #include <linux/locks.h>
 #include <linux/limits.h>
-#define __NO_VERSION__
 #include <linux/module.h>
 #include <linux/smp_lock.h>
 
--- trivial-2.4.20-pre1/fs/super.c.orig	2002-08-12 11:47:55.000000000 +1000
+++ trivial-2.4.20-pre1/fs/super.c	2002-08-12 11:47:56.000000000 +1000
@@ -31,7 +31,6 @@
 #include <asm/uaccess.h>
 
 #include <linux/kmod.h>
-#define __NO_VERSION__
 #include <linux/module.h>
 
 LIST_HEAD(super_blocks);
--- trivial-2.4.20-pre1/net/ipv4/netfilter/ip_conntrack_core.c.orig	2002-08-12 11:47:55.000000000 +1000
+++ trivial-2.4.20-pre1/net/ipv4/netfilter/ip_conntrack_core.c	2002-08-12 11:47:56.000000000 +1000
@@ -6,7 +6,6 @@
    Public Licence. */
 
 #ifdef MODULE
-#define __NO_VERSION__
 #endif
 #include <linux/version.h>
 #include <linux/config.h>
--- trivial-2.4.20-pre1/net/ipv4/netfilter/ip_conntrack_proto_tcp.c.orig	2002-08-12 11:47:55.000000000 +1000
+++ trivial-2.4.20-pre1/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2002-08-12 11:47:56.000000000 +1000
@@ -1,4 +1,3 @@
-#define __NO_VERSION__
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <linux/timer.h>
--- trivial-2.4.20-pre1/net/ipv4/netfilter/ip_nat_core.c.orig	2002-08-12 11:47:55.000000000 +1000
+++ trivial-2.4.20-pre1/net/ipv4/netfilter/ip_nat_core.c	2002-08-12 11:47:56.000000000 +1000
@@ -3,7 +3,6 @@
 /* (c) 1999 Paul `Rusty' Russell.  Licenced under the GNU General
    Public Licence. */
 #ifdef MODULE
-#define __NO_VERSION__
 #endif
 #include <linux/version.h>
 #include <linux/module.h>
--- trivial-2.4.20-pre1/net/ipv4/netfilter/ip_nat_rule.c.orig	2002-08-12 11:47:55.000000000 +1000
+++ trivial-2.4.20-pre1/net/ipv4/netfilter/ip_nat_rule.c	2002-08-12 11:47:56.000000000 +1000
@@ -1,5 +1,4 @@
 /* Everything about the rules for NAT. */
-#define __NO_VERSION__
 #include <linux/types.h>
 #include <linux/ip.h>
 #include <linux/netfilter.h>
--- trivial-2.4.20-pre1/net/ipv6/icmp.c.orig	2002-08-12 11:47:55.000000000 +1000
+++ trivial-2.4.20-pre1/net/ipv6/icmp.c	2002-08-12 11:47:56.000000000 +1000
@@ -27,7 +27,6 @@
  *					fragments.
  */
 
-#define __NO_VERSION__
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/types.h>
--- trivial-2.4.20-pre1/net/ipv6/ipv6_sockglue.c.orig	2002-08-12 11:47:55.000000000 +1000
+++ trivial-2.4.20-pre1/net/ipv6/ipv6_sockglue.c	2002-08-12 11:47:56.000000000 +1000
@@ -21,7 +21,6 @@
  *	o	Return an optlen of the truncated length if need be
  */
 
-#define __NO_VERSION__
 #include <linux/module.h>
 #include <linux/config.h>
 #include <linux/errno.h>
--- trivial-2.4.20-pre1/net/ipv6/mcast.c.orig	2002-08-12 11:47:55.000000000 +1000
+++ trivial-2.4.20-pre1/net/ipv6/mcast.c	2002-08-12 11:47:56.000000000 +1000
@@ -20,7 +20,6 @@
  *	yoshfuji	: fix format of router-alert option
  */
 
-#define __NO_VERSION__
 #include <linux/config.h>
 #include <linux/module.h>
 #include <linux/errno.h>
--- trivial-2.4.20-pre1/net/ipv6/ndisc.c.orig	2002-08-12 11:47:55.000000000 +1000
+++ trivial-2.4.20-pre1/net/ipv6/ndisc.c	2002-08-12 11:47:56.000000000 +1000
@@ -41,7 +41,6 @@
 #define ND_PRINTK2 ND_PRINTK
 #endif
 
-#define __NO_VERSION__
 #include <linux/module.h>
 #include <linux/config.h>
 #include <linux/errno.h>
--- trivial-2.4.20-pre1/net/ipv6/sit.c.orig	2002-08-12 11:47:55.000000000 +1000
+++ trivial-2.4.20-pre1/net/ipv6/sit.c	2002-08-12 11:47:56.000000000 +1000
@@ -18,7 +18,6 @@
  * Nate Thompson <nate@thebog.net>:		6to4 support
  */
 
-#define __NO_VERSION__
 #include <linux/config.h>
 #include <linux/module.h>
 #include <linux/errno.h>
--- trivial-2.4.20-pre1/net/ipv6/tcp_ipv6.c.orig	2002-08-12 11:47:55.000000000 +1000
+++ trivial-2.4.20-pre1/net/ipv6/tcp_ipv6.c	2002-08-12 11:47:56.000000000 +1000
@@ -21,7 +21,6 @@
  *      2 of the License, or (at your option) any later version.
  */
 
-#define __NO_VERSION__
 #include <linux/module.h>
 #include <linux/config.h>
 #include <linux/errno.h>
--- trivial-2.4.20-pre1/net/irda/irproc.c.orig	2002-08-12 11:47:55.000000000 +1000
+++ trivial-2.4.20-pre1/net/irda/irproc.c	2002-08-12 11:47:56.000000000 +1000
@@ -25,7 +25,6 @@
 
 #include <linux/miscdevice.h>
 #include <linux/proc_fs.h>
-#define __NO_VERSION__
 #include <linux/module.h>
 
 #include <net/irda/irda.h>
--- trivial-2.4.20-pre1/net/netrom/nr_dev.c.orig	2002-08-12 11:47:56.000000000 +1000
+++ trivial-2.4.20-pre1/net/netrom/nr_dev.c	2002-08-12 11:47:56.000000000 +1000
@@ -19,7 +19,6 @@
  */
 
 #include <linux/config.h>
-#define __NO_VERSION__
 #include <linux/module.h>
 #include <linux/proc_fs.h>
 #include <linux/kernel.h>
--- trivial-2.4.20-pre1/net/rose/rose_dev.c.orig	2002-08-12 11:47:56.000000000 +1000
+++ trivial-2.4.20-pre1/net/rose/rose_dev.c	2002-08-12 11:47:56.000000000 +1000
@@ -15,7 +15,6 @@
  */
 
 #include <linux/config.h>
-#define __NO_VERSION__
 #include <linux/module.h>
 #include <linux/proc_fs.h>
 #include <linux/kernel.h>
--- trivial-2.4.20-pre1/net/sunrpc/stats.c.orig	2002-08-12 11:47:56.000000000 +1000
+++ trivial-2.4.20-pre1/net/sunrpc/stats.c	2002-08-12 11:47:56.000000000 +1000
@@ -12,7 +12,6 @@
  * Copyright (C) 1995, 1996, 1997 Olaf Kirch <okir@monad.swb.de>
  */
 
-#define __NO_VERSION__
 #include <linux/module.h>
 
 #include <linux/kernel.h>
--- trivial-2.4.20-pre1/net/sunrpc/sunrpc_syms.c.orig	2002-08-12 11:47:56.000000000 +1000
+++ trivial-2.4.20-pre1/net/sunrpc/sunrpc_syms.c	2002-08-12 11:47:56.000000000 +1000
@@ -6,7 +6,6 @@
  * Copyright (C) 1997 Olaf Kirch <okir@monad.swb.de>
  */
 
-#define __NO_VERSION__
 #include <linux/config.h>
 #include <linux/module.h>
 
--- trivial-2.4.20-pre1/net/sunrpc/sysctl.c.orig	2002-08-12 11:47:56.000000000 +1000
+++ trivial-2.4.20-pre1/net/sunrpc/sysctl.c	2002-08-12 11:47:56.000000000 +1000
@@ -14,7 +14,6 @@
 #include <linux/ctype.h>
 #include <linux/fs.h>
 #include <linux/sysctl.h>
-#define __NO_VERSION__
 #include <linux/module.h>
 
 #include <asm/uaccess.h>
-- 
  Don't blame me: the Monkey is driving
