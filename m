From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] 2.5.59 fix misspellings of "address" throughout the tree.
Date: Thu, 06 Feb 2003 16:55:59 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030206055746.8916B2C0D7@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: torvalds@transmeta.com
Cc: Gerard Roudier <groudier@free.fr>, Gerd Knorr <kraxel@bytesex.org>, Greg Ungerer <gerg@snapgear.com>, David McCullough <davidm@snapgear.com>, D Jeff Dionne <jeff@uclinux.org>, James Simmons <jsimmons@infradead.org>, geert@linux-m68k.org, Jaroslav Kysela <perex@suse.cz>, Kai Germaschewski <kai.germaschewski@gmx.de>, Karsten Keil <kkeil@suse.de>, Philip.Blundell@pobox.com, Tim Waugh <tim@cyberelk.net>, Ralph Metzler <ralph@convergence.de>, ak@suse.de, bjornw@axis.com, davidm@hpl.hp.com, dolbeau@irisa.fr, dwmw2@infradead.org, jgarzik@pobox.com, linux-scsi@vger.kernel.org, paulus@samba.org, rmk@arm.linux.org.uk, schwidefsky@de.ibm.com, t.sailer@alumni.ethz.ch, tadavis@lbl.gov, viro@math.psu.edu

From:  Steven Cole <elenstev@mesatop.com>

  Rusty,
  
  This patch fixes numerous misspellings of "address",
  both as "addres" and "adress".
  
  These all seem safe to change.  I didn't cc to lkml since
  this would just add to the general noise.
  
  I left one instance of "adress" alone, since I wasn't sure
  if it was safe to change it here:
  
  #diff -ur linux-2.5.59-badspelling/drivers/net/ac3200.c linux-2.5.59/drivers/net/ac3200.c
  #--- linux-2.5.59-badspelling/drivers/net/ac3200.c	Thu Jan 16 19:22:22 2003
  #+++ linux-2.5.59/drivers/net/ac3200.c	Thu Jan 30 14:42:05 2003
  #@@ -344,7 +344,7 @@
  # MODULE_PARM(io, "1-" __MODULE_STRING(MAX_AC32_CARDS) "i");
  # MODULE_PARM(irq, "1-" __MODULE_STRING(MAX_AC32_CARDS) "i");
  # MODULE_PARM(mem, "1-" __MODULE_STRING(MAX_AC32_CARDS) "i");
  #-MODULE_PARM_DESC(io, "I/O base adress(es)");
  #+MODULE_PARM_DESC(io, "I/O base address(es)");
  # MODULE_PARM_DESC(irq, "IRQ number(s)");
  # MODULE_PARM_DESC(mem, "Memory base address(es)");
  # MODULE_DESCRIPTION("Ansel AC3200 EISA ethernet driver");
  
  Here is the diffstat and the patch.  Enjoy.
  
  Steven
  
   Documentation/networking/alias.txt       |    2 +-
   Documentation/networking/bonding.txt     |    2 +-
   Documentation/s390/cds.txt               |    2 +-
   Documentation/scsi/ChangeLog.sym53c8xx_2 |    2 +-
   arch/cris/boot/compressed/misc.c         |    2 +-
   arch/cris/drivers/eeprom.c               |    2 +-
   arch/ia64/sn/io/sn2/pcibr/pcibr_dvr.c    |    2 +-
   arch/ia64/sn/io/sn2/pcibr/pcibr_error.c  |    2 +-
   arch/x86_64/kernel/head.S                |    2 +-
   drivers/char/applicom.c                  |    2 +-
   drivers/hotplug/ibmphp_pci.c             |    2 +-
   drivers/ieee1394/raw1394.c               |    2 +-
   drivers/isdn/hardware/eicon/mi_pc.h      |    2 +-
   drivers/isdn/hisax/elsa.c                |    2 +-
   drivers/media/dvb/av7110/saa7146_core.c  |    2 +-
   drivers/media/video/bt832.c              |    2 +-
   drivers/media/video/bt832.h              |    2 +-
   drivers/net/bonding.c                    |    2 +-
   drivers/net/tulip/dmfe.c                 |   12 ++++++------
   drivers/net/znet.c                       |    2 +-
   drivers/parport/parport_pc.c             |    2 +-
   drivers/scsi/sym53c8xx_2/sym_glue.h      |    4 ++--
   drivers/scsi/sym53c8xx_2/sym_hipd.c      |    2 +-
   drivers/scsi/sym53c8xx_defs.h            |    4 ++--
   drivers/serial/8250_pnp.c                |    2 +-
   drivers/video/pm3fb.c                    |    4 ++--
   drivers/video/sstfb.c                    |    2 +-
   fs/jffs2/wbuf.c                          |    2 +-
   include/asm-arm/arch-iop310/dma.h        |    2 +-
   include/asm-m68knommu/mcfmbus.h          |    2 +-
   include/asm-m68knommu/mcfpci.h           |    2 +-
   include/asm-ppc/ppcboot.h                |    2 +-
   include/asm-s390/cio.h                   |    2 +-
   include/asm-s390x/cio.h                  |    2 +-
   sound/pci/es1968.c                       |    2 +-
   sound/pci/fm801.c                        |    2 +-
   36 files changed, 44 insertions(+), 44 deletions(-)
  

--- trivial-2.5-bk/Documentation/networking/alias.txt.orig	2003-02-06 16:30:25.000000000 +1100
+++ trivial-2.5-bk/Documentation/networking/alias.txt	2003-02-06 16:30:25.000000000 +1100
@@ -2,7 +2,7 @@
 IP-Aliasing:
 ============
 
-IP-aliases are additional IP-adresses/masks hooked up to a base 
+IP-aliases are additional IP-addresses/masks hooked up to a base 
 interface by adding a colon and a string when running ifconfig. 
 This string is usually numeric, but this is not a must.
 
--- trivial-2.5-bk/Documentation/networking/bonding.txt.orig	2003-02-06 16:30:25.000000000 +1100
+++ trivial-2.5-bk/Documentation/networking/bonding.txt	2003-02-06 16:30:25.000000000 +1100
@@ -258,7 +258,7 @@
         Specifies the ip addresses to use when arp_interval is > 0. These are
         the targets of the ARP request sent to determine the health of the link
         to the targets. Specify these values in ddd.ddd.ddd.ddd format.
-        Multiple ip adresses must be seperated by a comma. At least one ip
+        Multiple ip addresses must be seperated by a comma. At least one ip
         address needs to be given for ARP monitoring to work. The maximum number
         of targets that can be specified is set at 16.
 
--- trivial-2.5-bk/Documentation/s390/cds.txt.orig	2003-02-06 16:30:25.000000000 +1100
+++ trivial-2.5-bk/Documentation/s390/cds.txt	2003-02-06 16:30:25.000000000 +1100
@@ -286,7 +286,7 @@
 
 struct ccw1 {
       __u8  cmd_code;/* command code */
-      __u8  flags;   /* flags, like IDA adressing, etc. */
+      __u8  flags;   /* flags, like IDA addressing, etc. */
       __u16 count;   /* byte count */
       __u32 cda;     /* data address */
 } __attribute__ ((packed,aligned(8)));
--- trivial-2.5-bk/Documentation/scsi/ChangeLog.sym53c8xx_2.orig	2003-02-06 16:30:25.000000000 +1100
+++ trivial-2.5-bk/Documentation/scsi/ChangeLog.sym53c8xx_2	2003-02-06 16:30:25.000000000 +1100
@@ -102,7 +102,7 @@
 Sun Sep 9 18:00 2001 Gerard Roudier 
 	* version sym-2.1.12-20010909
 	- Change my email address.
-	- Add infrastructure for the forthcoming 64 bit DMA adressing support.
+	- Add infrastructure for the forthcoming 64 bit DMA addressing support.
 	  (Based on PCI 64 bit patch from David S. Miller)
 	- Donnot use anymore vm_offset_t type.
 
--- trivial-2.5-bk/arch/cris/boot/compressed/misc.c.orig	2003-02-06 16:30:25.000000000 +1100
+++ trivial-2.5-bk/arch/cris/boot/compressed/misc.c	2003-02-06 16:30:25.000000000 +1100
@@ -13,7 +13,7 @@
  */
 
 /* where the piggybacked kernel image expects itself to live.
- * it is the same adress we use when we network load an uncompressed
+ * it is the same address we use when we network load an uncompressed
  * image into DRAM, and it is the address the kernel is linked to live
  * at by etrax100.ld.
  */
--- trivial-2.5-bk/arch/cris/drivers/eeprom.c.orig	2003-02-06 16:30:25.000000000 +1100
+++ trivial-2.5-bk/arch/cris/drivers/eeprom.c	2003-02-06 16:30:25.000000000 +1100
@@ -802,7 +802,7 @@
   return 1;
 }
 
-/* Reads from current adress. */
+/* Reads from current address. */
 
 static int read_from_eeprom(char * buf, int count)
 {
--- trivial-2.5-bk/arch/ia64/sn/io/sn2/pcibr/pcibr_dvr.c.orig	2003-02-06 16:30:25.000000000 +1100
+++ trivial-2.5-bk/arch/ia64/sn/io/sn2/pcibr/pcibr_dvr.c	2003-02-06 16:30:25.000000000 +1100
@@ -3505,7 +3505,7 @@
     } else
 	xio_port = pcibr_dmamap->bd_xio_port;
 
-    /* If this DMA is to an addres that
+    /* If this DMA is to an address that
      * refers back to this Bridge chip,
      * reduce it back to the correct
      * PCI MEM address.
--- trivial-2.5-bk/arch/ia64/sn/io/sn2/pcibr/pcibr_error.c.orig	2003-02-06 16:30:25.000000000 +1100
+++ trivial-2.5-bk/arch/ia64/sn/io/sn2/pcibr/pcibr_error.c	2003-02-06 16:30:25.000000000 +1100
@@ -1874,7 +1874,7 @@
 			BRIDGE_ERRUPPR_ADDRMASK) << 32)));
 
     /*
-     * need to ensure that the xtalk adress in ioe
+     * need to ensure that the xtalk address in ioe
      * maps to PCI error address read from bridge.
      * How to convert PCI address back to Xtalk address ?
      * (better idea: convert XTalk address to PCI address
--- trivial-2.5-bk/arch/x86_64/kernel/head.S.orig	2003-02-06 16:30:25.000000000 +1100
+++ trivial-2.5-bk/arch/x86_64/kernel/head.S	2003-02-06 16:30:25.000000000 +1100
@@ -112,7 +112,7 @@
 	jnz   second	
 	
 	/* Load new GDT with the 64bit segment using 32bit descriptor */
-	/* to avoid 32bit relocations we use fixed adresses here */
+	/* to avoid 32bit relocations we use fixed addresses here */
 	movl	$(pGDT32 - __START_KERNEL_map), %eax
 	lgdt	(%eax)
 
--- trivial-2.5-bk/drivers/char/applicom.c.orig	2003-02-06 16:30:25.000000000 +1100
+++ trivial-2.5-bk/drivers/char/applicom.c	2003-02-06 16:30:25.000000000 +1100
@@ -14,7 +14,7 @@
 /* et passe en argument a acinit, mais est scrute sur le bus pour s'adapter  */
 /* au nombre de cartes presentes sur le bus. IOCL code 6 affichait V2.4.3    */
 /* F.LAFORSE 28/11/95 creation de fichiers acXX.o avec les differentes       */
-/* adresses de base des cartes, IOCTL 6 plus complet                         */
+/* addresses de base des cartes, IOCTL 6 plus complet                         */
 /* J.PAGET le 19/08/96 copie de la version V2.6 en V2.8.0 sans modification  */
 /* de code autre que le texte V2.6.1 en V2.8.0                               */
 /*****************************************************************************/
--- trivial-2.5-bk/drivers/hotplug/ibmphp_pci.c.orig	2003-02-06 16:30:25.000000000 +1100
+++ trivial-2.5-bk/drivers/hotplug/ibmphp_pci.c	2003-02-06 16:30:25.000000000 +1100
@@ -491,7 +491,7 @@
 				pci_bus_write_config_dword (ibmphp_pci_bus, devfn, address[count], func->pfmem[count]->start);
 
 				/*_______________This is for debugging purposes only______________________________*/				
-				debug ("b4 writing, start addres is %x\n", func->pfmem[count]->start);
+				debug ("b4 writing, start address is %x\n", func->pfmem[count]->start);
 				pci_bus_read_config_dword (ibmphp_pci_bus, devfn, address[count], &bar[count]);
 				debug ("after writing, start address is %x\n", bar[count]);
 				/*_________________________________________________________________________________*/
--- trivial-2.5-bk/drivers/ieee1394/raw1394.c.orig	2003-02-06 16:30:25.000000000 +1100
+++ trivial-2.5-bk/drivers/ieee1394/raw1394.c	2003-02-06 16:30:25.000000000 +1100
@@ -238,7 +238,7 @@
                 list_del(&hi->list);
                 host_count--;
                 /* 
-                   FIXME: adressranges should be removed 
+                   FIXME: addressranges should be removed 
                    and fileinfo states should be initialized
                    (including setting generation to 
                    internal-generation ...)
--- trivial-2.5-bk/drivers/isdn/hardware/eicon/mi_pc.h.orig	2003-02-06 16:30:25.000000000 +1100
+++ trivial-2.5-bk/drivers/isdn/hardware/eicon/mi_pc.h	2003-02-06 16:30:25.000000000 +1100
@@ -120,7 +120,7 @@
 #define MQ_CACHED_ADDR(x)               (((x) & 0x1fffffffL) | 0x80000000L)
 #define MQ_UNCACHED_ADDR(x)             (((x) & 0x1fffffffL) | 0xa0000000L)
 /*--------------------------------------------------------------------------------------------*/
-/* Additional definitions reflecting the different adress map of the  SERVER 4BRI V2          */
+/* Additional definitions reflecting the different address map of the  SERVER 4BRI V2          */
 #define MQ2_BREG_RISC                   0x0200      /* RISC Reset ect                         */
 #define MQ2_BREG_IRQ_TEST               0x0400      /* Interrupt request, no CPU interaction  */
 #define MQ2_BOARD_DSP_OFFSET            0x800000    /* PC relative On board DSP regs offset   */
--- trivial-2.5-bk/drivers/isdn/hisax/elsa.c.orig	2003-02-06 16:30:25.000000000 +1100
+++ trivial-2.5-bk/drivers/isdn/hisax/elsa.c	2003-02-06 16:30:25.000000000 +1100
@@ -73,7 +73,7 @@
 /* PCI stuff */
 #define ELSA_PCI_IRQ_MASK	0x04
 
-/* ITAC Registeradressen (only Microlink PC) */
+/* ITAC Registeraddressen (only Microlink PC) */
 #define ITAC_SYS	0x34
 #define ITAC_ISEN	0x48
 #define ITAC_RFIE	0x4A
--- trivial-2.5-bk/drivers/media/dvb/av7110/saa7146_core.c.orig	2003-02-06 16:30:25.000000000 +1100
+++ trivial-2.5-bk/drivers/media/dvb/av7110/saa7146_core.c	2003-02-06 16:30:25.000000000 +1100
@@ -494,7 +494,7 @@
 
 	saa->revision = (rev & 0xf);
 
-	/* remap the memory from virtual to physical adress */
+	/* remap the memory from virtual to physical address */
 	saa->mem = ioremap ((saa->device->resource[0].start)
 			    &PCI_BASE_ADDRESS_MEM_MASK, 0x1000);
 
--- trivial-2.5-bk/drivers/media/video/bt832.c.orig	2003-02-06 16:30:25.000000000 +1100
+++ trivial-2.5-bk/drivers/media/video/bt832.c	2003-02-06 16:30:25.000000000 +1100
@@ -1,5 +1,5 @@
 /* Driver for Bt832 CMOS Camera Video Processor
-    i2c-adresses: 0x88 or 0x8a
+    i2c-addresses: 0x88 or 0x8a
 
   The BT832 interfaces to a Quartzsight Digital Camera (352x288, 25 or 30 fps)
   via a 9 pin connector ( 4-wire SDATA, 2-wire i2c, SCLK, VCC, GND).
--- trivial-2.5-bk/drivers/media/video/bt832.h.orig	2003-02-06 16:30:25.000000000 +1100
+++ trivial-2.5-bk/drivers/media/video/bt832.h	2003-02-06 16:30:25.000000000 +1100
@@ -4,7 +4,7 @@
   color digital camera directly to video capture devices via an 8-bit,
   4:2:2 YUV or YCrCb video interface.
 
- i2c adresses: 0x88 or 0x8a
+ i2c addresses: 0x88 or 0x8a
  */
 
 /* The 64 registers: */
--- trivial-2.5-bk/drivers/net/bonding.c.orig	2003-02-06 16:30:25.000000000 +1100
+++ trivial-2.5-bk/drivers/net/bonding.c	2003-02-06 16:30:25.000000000 +1100
@@ -2547,7 +2547,7 @@
 
 /* 
  * in XOR mode, we determine the output device by performing xor on
- * the source and destination hw adresses.  If this device is not 
+ * the source and destination hw addresses.  If this device is not 
  * enabled, find the next slave following this xor slave. 
  */
 static int bond_xmit_xor(struct sk_buff *skb, struct net_device *dev)
--- trivial-2.5-bk/drivers/net/tulip/dmfe.c.orig	2003-02-06 16:30:25.000000000 +1100
+++ trivial-2.5-bk/drivers/net/tulip/dmfe.c	2003-02-06 16:30:25.000000000 +1100
@@ -1337,7 +1337,7 @@
 
 /*
  *	Send a setup frame for DM9132
- *	This setup frame initilize DM910X addres filter mode
+ *	This setup frame initilize DM910X address filter mode
 */
 
 static void dm9132_id_table(struct DEVICE *dev, int mc_cnt)
@@ -1380,7 +1380,7 @@
 
 /*
  *	Send a setup frame for DM9102/DM9102A
- *	This setup frame initilize DM910X addres filter mode
+ *	This setup frame initilize DM910X address filter mode
  */
 
 static void send_filter_frame(struct DEVICE *dev, int mc_cnt)
@@ -1673,11 +1673,11 @@
 		phy_write_1bit(ioaddr, PHY_DATA_0);
 		phy_write_1bit(ioaddr, PHY_DATA_1);
 
-		/* Send Phy addres */
+		/* Send Phy address */
 		for (i = 0x10; i > 0; i = i >> 1)
 			phy_write_1bit(ioaddr, phy_addr & i ? PHY_DATA_1 : PHY_DATA_0);
 
-		/* Send register addres */
+		/* Send register address */
 		for (i = 0x10; i > 0; i = i >> 1)
 			phy_write_1bit(ioaddr, offset & i ? PHY_DATA_1 : PHY_DATA_0);
 
@@ -1722,11 +1722,11 @@
 		phy_write_1bit(ioaddr, PHY_DATA_1);
 		phy_write_1bit(ioaddr, PHY_DATA_0);
 
-		/* Send Phy addres */
+		/* Send Phy address */
 		for (i = 0x10; i > 0; i = i >> 1)
 			phy_write_1bit(ioaddr, phy_addr & i ? PHY_DATA_1 : PHY_DATA_0);
 
-		/* Send register addres */
+		/* Send register address */
 		for (i = 0x10; i > 0; i = i >> 1)
 			phy_write_1bit(ioaddr, offset & i ? PHY_DATA_1 : PHY_DATA_0);
 
--- trivial-2.5-bk/drivers/net/znet.c.orig	2003-02-06 16:30:25.000000000 +1100
+++ trivial-2.5-bk/drivers/net/znet.c	2003-02-06 16:30:25.000000000 +1100
@@ -357,7 +357,7 @@
 	znet->tx_cur += sizeof(struct i82593_conf_block)/2;
 	outb(OP0_CONFIGURE | CR0_CHNL, ioaddr);
 
-	/* XXX FIXME maz : Add multicast adresses here, so having a
+	/* XXX FIXME maz : Add multicast addresses here, so having a
 	 * multicast address configured isn't equal to IFF_ALLMULTI */
 }
 

--- trivial-2.5-bk/drivers/parport/parport_pc.c.orig	2003-02-06 16:30:25.000000000 +1100
+++ trivial-2.5-bk/drivers/parport/parport_pc.c	2003-02-06 16:30:25.000000000 +1100
@@ -1634,7 +1634,7 @@
 /*
  * Checks for port existence, all ports support SPP MODE
  * Returns: 
- *         0           :  No parallel port at this adress
+ *         0           :  No parallel port at this address
  *  PARPORT_MODE_PCSPP :  SPP port detected 
  *                        (if the user specified an ioport himself,
  *                         this shall always be the case!)
--- trivial-2.5-bk/drivers/scsi/sym53c8xx_2/sym_glue.h.orig	2003-02-06 16:30:25.000000000 +1100
+++ trivial-2.5-bk/drivers/scsi/sym53c8xx_2/sym_glue.h	2003-02-06 16:30:25.000000000 +1100
@@ -263,7 +263,7 @@
 #endif
 
 /*
- *  If the CPU and the chip use same endian-ness adressing,
+ *  If the CPU and the chip use same endian-ness addressing,
  *  no byte reordering is needed for script patching.
  *  Macro cpu_to_scr() is to be used for script patching.
  *  Macro scr_to_cpu() is to be used for getting a DWORD 
@@ -297,7 +297,7 @@
  *  would have been correctly designed for PCI, this 
  *  option would be useless.
  *
- *  If the CPU and the chip use same endian-ness adressing,
+ *  If the CPU and the chip use same endian-ness addressing,
  *  no byte reordering is needed for accessing chip io 
  *  registers. Functions suffixed by '_raw' are assumed 
  *  to access the chip over the PCI without doing byte 
--- trivial-2.5-bk/drivers/scsi/sym53c8xx_2/sym_hipd.c.orig	2003-02-06 16:30:25.000000000 +1100
+++ trivial-2.5-bk/drivers/scsi/sym53c8xx_2/sym_hipd.c	2003-02-06 16:30:25.000000000 +1100
@@ -1235,7 +1235,7 @@
  *  	s4:	scntl4 (see the manual)
  *
  *  current script command:
- *  	dsp:	script adress (relative to start of script).
+ *  	dsp:	script address (relative to start of script).
  *  	dbc:	first word of script command.
  *
  *  First 24 register of the chip:
--- trivial-2.5-bk/drivers/scsi/sym53c8xx_defs.h.orig	2003-02-06 16:30:25.000000000 +1100
+++ trivial-2.5-bk/drivers/scsi/sym53c8xx_defs.h	2003-02-06 16:30:25.000000000 +1100
@@ -487,7 +487,7 @@
 #endif
 
 /*
- *  If the CPU and the NCR use same endian-ness adressing,
+ *  If the CPU and the NCR use same endian-ness addressing,
  *  no byte reordering is needed for script patching.
  *  Macro cpu_to_scr() is to be used for script patching.
  *  Macro scr_to_cpu() is to be used for getting a DWORD 
@@ -521,7 +521,7 @@
  *  would have been correctly designed for PCI, this 
  *  option would be useless.
  *
- *  If the CPU and the NCR use same endian-ness adressing,
+ *  If the CPU and the NCR use same endian-ness addressing,
  *  no byte reordering is needed for accessing chip io 
  *  registers. Functions suffixed by '_raw' are assumed 
  *  to access the chip over the PCI without doing byte 
--- trivial-2.5-bk/drivers/serial/8250_pnp.c.orig	2003-02-06 16:30:25.000000000 +1100
+++ trivial-2.5-bk/drivers/serial/8250_pnp.c	2003-02-06 16:30:25.000000000 +1100
@@ -348,7 +348,7 @@
  * Given a complete unknown PnP device, try to use some heuristics to
  * detect modems. Currently use such heuristic set:
  *     - dev->name or dev->bus->name must contain "modem" substring;
- *     - device must have only one IO region (8 byte long) with base adress
+ *     - device must have only one IO region (8 byte long) with base address
  *       0x2e8, 0x3e8, 0x2f8 or 0x3f8.
  *
  * Such detection looks very ugly, but can detect at least some of numerous
--- trivial-2.5-bk/drivers/video/pm3fb.c.orig	2003-02-06 16:30:25.000000000 +1100
+++ trivial-2.5-bk/drivers/video/pm3fb.c	2003-02-06 16:30:25.000000000 +1100
@@ -2325,7 +2325,7 @@
 	PM3_WRITE_REG(PM3ForegroundColor, fgx);
 	PM3_WRITE_REG(PM3FillBackgroundColor, bgx);
 
-	/* WARNING : adress select X need to specify 8 bits for fontwidth <= 8 */
+	/* WARNING : address select X need to specify 8 bits for fontwidth <= 8 */
 	/* and 16 bits for fontwidth <= 16 */
 	/* same in _putcs, same for Y and fontheight */
 	if (fontwidth(p) <= 8)
@@ -2438,7 +2438,7 @@
 	PM3_WRITE_REG(PM3ForegroundColor, fgx);
 	PM3_WRITE_REG(PM3FillBackgroundColor, bgx);
 
-	/* WARNING : adress select X need to specify 8 bits for fontwidth <= 8 */
+	/* WARNING : address select X need to specify 8 bits for fontwidth <= 8 */
 	/* and 16 bits for fontwidth <= 16 */
 	/* same in _putc, same for Y and fontheight */
 	if (fontwidth(p) <= 8)
--- trivial-2.5-bk/drivers/video/sstfb.c.orig	2003-02-06 16:30:25.000000000 +1100
+++ trivial-2.5-bk/drivers/video/sstfb.c	2003-02-06 16:30:25.000000000 +1100
@@ -21,7 +21,7 @@
  */
 
 /*
- * The voodoo1 has the following memory mapped adress space:
+ * The voodoo1 has the following memory mapped address space:
  * 0x000000 - 0x3fffff : registers              (4MB)
  * 0x400000 - 0x7fffff : linear frame buffer    (4MB)
  * 0x800000 - 0xffffff : texture memory         (8MB)
--- trivial-2.5-bk/fs/jffs2/wbuf.c.orig	2003-02-06 16:30:25.000000000 +1100
+++ trivial-2.5-bk/fs/jffs2/wbuf.c	2003-02-06 16:30:25.000000000 +1100
@@ -256,7 +256,7 @@
 	if (!c->wbuf)
 		return jffs2_flash_direct_writev(c, invecs, count, to, retlen);
 	
-	/* If wbuf_ofs is not initialized, set it to target adress */
+	/* If wbuf_ofs is not initialized, set it to target address */
 	if (c->wbuf_ofs == 0xFFFFFFFF) {
 		c->wbuf_ofs = PAGE_DIV(to);
 		c->wbuf_len = PAGE_MOD(to);			
--- trivial-2.5-bk/include/asm-arm/arch-iop310/dma.h.orig	2003-02-06 16:30:25.000000000 +1100
+++ trivial-2.5-bk/include/asm-arm/arch-iop310/dma.h	2003-02-06 16:30:25.000000000 +1100
@@ -69,7 +69,7 @@
  */
 typedef struct _dma_desc
 {
-	u32 NDAR;					/* next descriptor adress */
+	u32 NDAR;					/* next descriptor address */
 	u32 PDAR;					/* PCI address */
 	u32 PUADR;					/* upper PCI address */
 	u32 LADR;					/* local address */
--- trivial-2.5-bk/include/asm-m68knommu/mcfmbus.h.orig	2003-02-06 16:30:25.000000000 +1100
+++ trivial-2.5-bk/include/asm-m68knommu/mcfmbus.h	2003-02-06 16:30:25.000000000 +1100
@@ -23,7 +23,7 @@
 
 
 /*
-*	Define the 5307 MBUS register set adresses
+*	Define the 5307 MBUS register set addresses
 */
 
 #define MCFMBUS_MADR	0x00
--- trivial-2.5-bk/include/asm-m68knommu/mcfpci.h.orig	2003-02-06 16:30:25.000000000 +1100
+++ trivial-2.5-bk/include/asm-m68knommu/mcfpci.h	2003-02-06 16:30:25.000000000 +1100
@@ -17,7 +17,7 @@
 #ifdef CONFIG_PCI
 
 /*
- *	Address regions in the PCI addres space are not mapped into the
+ *	Address regions in the PCI address space are not mapped into the
  *	normal memory space of the ColdFire. They must be accessed via
  *	handler routines. This is easy for I/O space (inb/outb/etc) but
  *	needs some code changes to support ordinary memory. Interrupts
--- trivial-2.5-bk/include/asm-ppc/ppcboot.h.orig	2003-02-06 16:30:25.000000000 +1100
+++ trivial-2.5-bk/include/asm-ppc/ppcboot.h	2003-02-06 16:30:25.000000000 +1100
@@ -57,7 +57,7 @@
 #endif
 	unsigned long	bi_bootflags;	/* boot / reboot flag (for LynxOS) */
 	unsigned long	bi_ip_addr;	/* IP Address */
-	unsigned char	bi_enetaddr[6];	/* Ethernet adress */
+	unsigned char	bi_enetaddr[6];	/* Ethernet address */
 	unsigned short	bi_ethspeed;	/* Ethernet speed in Mbps */
 	unsigned long	bi_intfreq;	/* Internal Freq, in MHz */
 	unsigned long	bi_busfreq;	/* Bus Freq, in MHz */
--- trivial-2.5-bk/include/asm-s390/cio.h.orig	2003-02-06 16:30:25.000000000 +1100
+++ trivial-2.5-bk/include/asm-s390/cio.h	2003-02-06 16:30:25.000000000 +1100
@@ -111,7 +111,7 @@
 
 struct ccw1 {
 	__u8  cmd_code;		/* command code */
-	__u8  flags;   		/* flags, like IDA adressing, etc. */
+	__u8  flags;   		/* flags, like IDA addressing, etc. */
 	__u16 count;   		/* byte count */
 	__u32 cda;     		/* data address */
 } __attribute__ ((packed,aligned(8)));
--- trivial-2.5-bk/include/asm-s390x/cio.h.orig	2003-02-06 16:30:25.000000000 +1100
+++ trivial-2.5-bk/include/asm-s390x/cio.h	2003-02-06 16:30:25.000000000 +1100
@@ -111,7 +111,7 @@
 
 struct ccw1 {
 	__u8  cmd_code;		/* command code */
-	__u8  flags;   		/* flags, like IDA adressing, etc. */
+	__u8  flags;   		/* flags, like IDA addressing, etc. */
 	__u16 count;   		/* byte count */
 	__u32 cda;     		/* data address */
 } __attribute__ ((packed,aligned(8)));
--- trivial-2.5-bk/sound/pci/es1968.c.orig	2003-02-06 16:30:25.000000000 +1100
+++ trivial-2.5-bk/sound/pci/es1968.c	2003-02-06 16:30:26.000000000 +1100
@@ -1414,7 +1414,7 @@
    * DMA memory management *
    *************************/
 
-/* Because the Maestro can only take adresses relative to the PCM base adress
+/* Because the Maestro can only take addresses relative to the PCM base address
    register :( */
 
 static int calc_available_memory_size(es1968_t *chip)
--- trivial-2.5-bk/sound/pci/fm801.c.orig	2003-02-06 16:30:25.000000000 +1100
+++ trivial-2.5-bk/sound/pci/fm801.c	2003-02-06 16:30:26.000000000 +1100
@@ -130,7 +130,7 @@
 	struct resource *res_port;
 	unsigned int multichannel: 1,	/* multichannel support */
 		     secondary: 1;	/* secondary codec */
-	unsigned char secondary_addr;	/* addres of the secondary codec */
+	unsigned char secondary_addr;	/* address of the secondary codec */
 
 	unsigned short ply_ctrl; /* playback control */
 	unsigned short cap_ctrl; /* capture control */
-- 
  Don't blame me: the Monkey is driving
  File: Steven Cole <elenstev@mesatop.com>: [PATCH] 2.5.59 fix misspellings of "address" throughout the tree.
