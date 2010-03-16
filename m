From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH 2/2 reresend] scsi: update URLs in source and Documentation
Date: Tue, 16 Mar 2010 12:30:55 -0700
Message-ID: <4B9FDC6F.7020408@oracle.com>
References: <1268759504.21384.29.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:53872 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399Ab0CPTc1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2010 15:32:27 -0400
In-Reply-To: <1268759504.21384.29.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Change torque.net references for SCSI drivers & tools to their current
locations (sg.danny.cz/sg).  Remove whitespace at ends of lines.

Same could be done for parport references at torque.net except that
those files don't seem to have a home now.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
---
 .mailmap                                |    2 
 Documentation/DocBook/scsi.tmpl         |    2 
 Documentation/scsi/scsi-generic.txt     |   30 ++---
 Documentation/scsi/scsi.txt             |   22 +--
 Documentation/scsi/scsi_mid_low_api.txt |  130 +++++++++++-----------
 MAINTAINERS                             |    2 
 drivers/scsi/Kconfig                    |    4 
 drivers/scsi/scsi_debug.c               |    2 
 include/scsi/sg.h                       |   19 +--
 9 files changed, 107 insertions(+), 106 deletions(-)

--- linux-2.6.33-rc4-git2.orig/.mailmap
+++ linux-2.6.33-rc4-git2/.mailmap
@@ -34,7 +34,7 @@ David Brownell <david-b@pacbell.net>
 David Woodhouse <dwmw2@shinybook.infradead.org>
 Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
 Domen Puncer <domen@coderock.org>
-Douglas Gilbert <dougg@torque.net>
+Douglas Gilbert <dgilbert@interlog.com>
 Ed L. Cashin <ecashin@coraid.com>
 Evgeniy Polyakov <johnpol@2ka.mipt.ru>
 Felipe W Damasio <felipewd@terra.com.br>
--- linux-2.6.33-rc4-git2.orig/MAINTAINERS
+++ linux-2.6.33-rc4-git2/MAINTAINERS
@@ -4705,7 +4705,7 @@ F:	drivers/scsi/sr*
 SCSI SG DRIVER
 M:	Doug Gilbert <dgilbert@interlog.com>
 L:	linux-scsi@vger.kernel.org
-W:	http://www.torque.net/sg
+W:	http://sg.danny.cz/sg/index.html
 S:	Maintained
 F:	drivers/scsi/sg.c
 F:	include/scsi/sg.h
--- linux-2.6.33-rc4-git2.orig/include/scsi/sg.h
+++ linux-2.6.33-rc4-git2/include/scsi/sg.h
@@ -16,7 +16,7 @@ Version 2 and 3 extensions to driver:
     Version: 3.5.34 (20060920)
     This version is for 2.6 series kernels.
 
-    For a full changelog see http://www.torque.net/sg
+    For a full changelog see http://sg.danny.cz/sg/index.html
 
 Map of SG verions to the Linux kernels in which they appear:
        ----------        ----------------------------------
@@ -44,28 +44,29 @@ Major new features in SG 3.x driver (cf 
  ** N.B. To use direct IO 'echo 1 > /proc/scsi/sg/allow_dio' or
          'echo 1 > /sys/module/sg/parameters/allow_dio' is needed.
          That attribute is 0 by default. **
- 
- Historical note: this SCSI pass-through driver has been known as "sg" for 
+
+ Historical note: this SCSI pass-through driver has been known as "sg" for
  a decade. In broader kernel discussions "sg" is used to refer to scatter
  gather techniques. The context should clarify which "sg" is referred to.
 
  Documentation
  =============
  A web site for the SG device driver can be found at:
-	http://www.torque.net/sg  [alternatively check the MAINTAINERS file]
+	http://sg.danny.cz/sg/index.html
+	[alternatively check the MAINTAINERS file]
  The documentation for the sg version 3 driver can be found at:
- 	http://www.torque.net/sg/p/sg_v3_ho.html
+ 	http://sg.danny.cz/sg/p/scsi-generic_v3.txt
  This is a rendering from DocBook source [change the extension to "sgml"
  or "xml"]. There are renderings in "ps", "pdf", "rtf" and "txt" (soon).
  The SG_IO ioctl is now found in other parts kernel (e.g. the block layer).
- For more information see http://www.torque.net/sg/sg_io.html
+ For more information see http://sg.danny.cz/sg/sg_io.html
 
  The older, version 2 documents discuss the original sg interface in detail:
-	http://www.torque.net/sg/p/scsi-generic.txt
-	http://www.torque.net/sg/p/scsi-generic_long.txt
+	http://sg.danny.cz/sg/p/scsi-generic.txt
+	http://sg.danny.cz/sg/p/scsi-generic_long.txt
  Also available: <kernel_source>/Documentation/scsi/scsi-generic.txt
 
- Utility and test programs are available at the sg web site. They are 
+ Utility and test programs are available at the sg web site. They are
  packaged as sg3_utils (for the lk 2.4 and 2.6 series) and sg_utils
  (for the lk 2.2 series).
 */
--- linux-2.6.33-rc4-git2.orig/drivers/scsi/Kconfig
+++ linux-2.6.33-rc4-git2/drivers/scsi/Kconfig
@@ -1594,8 +1594,8 @@ config SCSI_DEBUG
 	  each with multiple dummy SCSI devices (disks). It defaults to one
 	  host adapter with one dummy SCSI disk. Each dummy disk uses kernel
 	  RAM as storage (i.e. it is a ramdisk). To save space when multiple
-	  dummy disks are simulated, they share the same kernel RAM for 
-	  their storage. See <http://www.torque.net/sg/sdebug.html> for more
+	  dummy disks are simulated, they share the same kernel RAM for
+	  their storage. See <http://sg.danny.cz/sg/sdebug26.html> for more
 	  information. This driver is primarily of use to those testing the
 	  SCSI and block subsystems. If unsure, say N.
 
--- linux-2.6.33-rc4-git2.orig/drivers/scsi/scsi_debug.c
+++ linux-2.6.33-rc4-git2/drivers/scsi/scsi_debug.c
@@ -12,7 +12,7 @@
  *  SAS disks.
  *
  *
- *  For documentation see http://www.torque.net/sg/sdebug26.html
+ *  For documentation see http://sg.danny.cz/sg/sdebug26.html
  *
  *   D. Gilbert (dpg) work for Magneto-Optical device test [20010421]
  *   dpg: work for devfs large number of disks [20010809]
--- linux-2.6.33-rc4-git2.orig/Documentation/DocBook/scsi.tmpl
+++ linux-2.6.33-rc4-git2/Documentation/DocBook/scsi.tmpl
@@ -393,7 +393,7 @@
         </para>
         <para>
           For documentation see
-          <ulink url='http://www.torque.net/sg/sdebug26.html'>http://www.torque.net/sg/sdebug26.html</ulink>
+          <ulink url='http://sg.danny.cz/sg/sdebug26.html'>http://sg.danny.cz/sg/sdebug26.html</ulink>
         </para>
 <!-- !Edrivers/scsi/scsi_debug.c -->
       </sect2>
--- linux-2.6.33-rc4-git2.orig/Documentation/scsi/scsi.txt
+++ linux-2.6.33-rc4-git2/Documentation/scsi/scsi.txt
@@ -4,38 +4,38 @@ The Linux Documentation Project (LDP) ma
 the SCSI subsystem in the Linux kernel (lk) 2.4 series. See:
 http://www.tldp.org/HOWTO/SCSI-2.4-HOWTO . The LDP has single
 and multiple page HTML renderings as well as postscript and pdf.
-It can also be found at http://www.torque.net/scsi/SCSI-2.4-HOWTO .
+It can also be found at http://sg.danny.cz/scsi/SCSI-2.4-HOWTO/index.html .
 
 
 Notes on using modules in the SCSI subsystem
 ============================================
-The scsi support in the linux kernel can be modularized in a number of 
+The scsi support in the linux kernel can be modularized in a number of
 different ways depending upon the needs of the end user.  To understand
 your options, we should first define a few terms.
 
-The scsi-core (also known as the "mid level") contains the core of scsi 
+The scsi-core (also known as the "mid level") contains the core of scsi
 support.  Without it you can do nothing with any of the other scsi drivers.
 The scsi core support can be a module (scsi_mod.o), or it can be built into
-the kernel. If the core is a module, it must be the first scsi module 
-loaded, and if you unload the modules, it will have to be the last one 
+the kernel. If the core is a module, it must be the first scsi module
+loaded, and if you unload the modules, it will have to be the last one
 unloaded.  In practice the modprobe and rmmod commands (and "autoclean")
 will enforce the correct ordering of loading and unloading modules in
 the SCSI subsystem.
 
-The individual upper and lower level drivers can be loaded in any order 
+The individual upper and lower level drivers can be loaded in any order
 once the scsi core is present in the kernel (either compiled in or loaded
 as a module).  The disk driver (sd_mod.o), cdrom driver (sr_mod.o),
-tape driver ** (st.o) and scsi generics driver (sg.o) represent the upper 
-level drivers to support the various assorted devices which can be 
-controlled.  You can for example load the tape driver to use the tape drive, 
+tape driver ** (st.o) and scsi generics driver (sg.o) represent the upper
+level drivers to support the various assorted devices which can be
+controlled.  You can for example load the tape driver to use the tape drive,
 and then unload it once you have no further need for the driver (and release
 the associated memory).
 
 The lower level drivers are the ones that support the individual cards that
 are supported for the hardware platform that you are running under. Those
 individual cards are often called Host Bus Adapters (HBAs). For example the
-aic7xxx.o driver is used to control all recent SCSI controller cards from 
-Adaptec. Almost all lower level drivers can be built either as modules or 
+aic7xxx.o driver is used to control all recent SCSI controller cards from
+Adaptec. Almost all lower level drivers can be built either as modules or
 built into the kernel.
 
 
--- linux-2.6.33-rc4-git2.orig/Documentation/scsi/scsi_mid_low_api.txt
+++ linux-2.6.33-rc4-git2/Documentation/scsi/scsi_mid_low_api.txt
@@ -5,7 +5,7 @@
 Introduction
 ============
 This document outlines the interface between the Linux SCSI mid level and
-SCSI lower level drivers. Lower level drivers (LLDs) are variously called 
+SCSI lower level drivers. Lower level drivers (LLDs) are variously called
 host bus adapter (HBA) drivers and host drivers (HD). A "host" in this
 context is a bridge between a computer IO bus (e.g. PCI or ISA) and a
 single SCSI initiator port on a SCSI transport. An "initiator" port
@@ -24,8 +24,8 @@ directory).
 For example, the aic7xxx LLD controls Adaptec SCSI parallel interface
 (SPI) controllers based on that company's 7xxx chip series. The aic7xxx
 LLD can be built into the kernel or loaded as a module. There can only be
-one aic7xxx LLD running in a Linux system but it may be controlling many 
-HBAs. These HBAs might be either on PCI daughter-boards or built into 
+one aic7xxx LLD running in a Linux system but it may be controlling many
+HBAs. These HBAs might be either on PCI daughter-boards or built into
 the motherboard (or both). Some aic7xxx based HBAs are dual controllers
 and thus represent two hosts. Like most modern HBAs, each aic7xxx host
 has its own PCI device address. [The one-to-one correspondence between
@@ -39,20 +39,20 @@ This version of the document roughly mat
 
 Documentation
 =============
-There is a SCSI documentation directory within the kernel source tree, 
+There is a SCSI documentation directory within the kernel source tree,
 typically Documentation/scsi . Most documents are in plain
-(i.e. ASCII) text. This file is named scsi_mid_low_api.txt and can be 
-found in that directory. A more recent copy of this document may be found
-at http://www.torque.net/scsi/scsi_mid_low_api.txt.gz . 
+(i.e. ASCII) text. This file is named scsi_mid_low_api.txt and can be
+found in that directory.
+
 Many LLDs are documented there (e.g. aic7xxx.txt). The SCSI mid-level is
-briefly described in scsi.txt which contains a url to a document 
-describing the SCSI subsystem in the lk 2.4 series. Two upper level 
-drivers have documents in that directory: st.txt (SCSI tape driver) and 
+briefly described in scsi.txt which contains a url to a document
+describing the SCSI subsystem in the lk 2.4 series. Two upper level
+drivers have documents in that directory: st.txt (SCSI tape driver) and
 scsi-generic.txt (for the sg driver).
 
 Some documentation (or urls) for LLDs may be found in the C source code
 or in the same directory as the C source code. For example to find a url
-about the USB mass storage driver see the 
+about the USB mass storage driver see the
 /usr/src/linux/drivers/usb/storage directory.
 
 The Linux kernel source Documentation/DocBook/scsidrivers.tmpl file
@@ -67,7 +67,7 @@ the drivers/scsi directory. For example,
 file "xyz.h" and a source file "xyz.c". [Actually there is no good reason
 why this couldn't all be in one file; the header file is superfluous.] Some
 drivers that have been ported to several operating systems have more than
-two files. For example the aic7xxx driver has separate files for generic 
+two files. For example the aic7xxx driver has separate files for generic
 and OS-specific code (e.g. FreeBSD and Linux). Such drivers tend to have
 their own directory under the drivers/scsi directory.
 
@@ -85,7 +85,7 @@ to be hot plugged (and unplugged) during
 be referred to as the "hotplug" initialization model. The newer model is
 preferred as it can handle both traditional SCSI equipment that is
 permanently connected as well as modern "SCSI" devices (e.g. USB or
-IEEE 1394 connected digital cameras) that are hotplugged. Both 
+IEEE 1394 connected digital cameras) that are hotplugged. Both
 initialization models are discussed in the following sections.
 
 An LLD interfaces to the SCSI subsystem several ways:
@@ -103,9 +103,9 @@ supplied functions" below.
 Those functions in group b) are listed in a section entitled "Interface
 functions" below. Their function pointers are placed in the members of
 "struct scsi_host_template", an instance of which is passed to
-scsi_host_alloc() ** .  Those interface functions that the LLD does not 
-wish to supply should have NULL placed in the corresponding member of 
-struct scsi_host_template.  Defining an instance of struct 
+scsi_host_alloc() ** .  Those interface functions that the LLD does not
+wish to supply should have NULL placed in the corresponding member of
+struct scsi_host_template.  Defining an instance of struct
 scsi_host_template at file scope will cause NULL to be  placed in function
  pointer members not explicitly initialized.
 
@@ -115,7 +115,7 @@ that are shared with the mid level and o
 
 All functions defined within an LLD and all data defined at file scope
 should be static. For example the slave_alloc() function in an LLD
-called "xxx" could be defined as 
+called "xxx" could be defined as
 "static int xxx_slave_alloc(struct scsi_device * sdev) { /* code */ }"
 
 ** the scsi_host_alloc() function is a replacement for the rather vaguely
@@ -143,7 +143,7 @@ aware of an LLD when that LLD registers 
 
 At some later time, the LLD becomes aware of an HBA and what follows
 is a typical sequence of calls between the LLD and the mid level.
-This example shows the mid level scanning the newly introduced HBA for 3 
+This example shows the mid level scanning the newly introduced HBA for 3
 scsi devices of which only the first 2 respond:
 
      HBA PROBE: assume 2 SCSI devices found in scan
@@ -184,7 +184,7 @@ scsi_remove_host() ---------+
                      slave_destroy()
 scsi_host_put()
 ------------------------------------------------------------
-                     
+
 It may be useful for a LLD to keep track of struct Scsi_Host instances
 (a pointer is returned by scsi_host_alloc()). Such instances are "owned"
 by the mid-level.  struct Scsi_Host instances are freed from
@@ -296,7 +296,7 @@ exit_this_scsi_driver() ----+
                         release()   -->   scsi_unregister()
 ------------------------------------------------------------
 
-An LLD need not define slave_destroy() (i.e. it is optional). 
+An LLD need not define slave_destroy() (i.e. it is optional).
 
 The shortcoming of the "passive initialization model" is that host
 registration and de-registration are (typically) tied to LLD initialization
@@ -317,7 +317,7 @@ where they do.
 
 There are 3 reference counting functions of interest associated with
 struct Scsi_Host:
-  - scsi_host_alloc(): returns a pointer to new instance of struct 
+  - scsi_host_alloc(): returns a pointer to new instance of struct
         Scsi_Host which has its reference count ^^ set to 1
   - scsi_host_get(): adds 1 to the reference count of the given instance
   - scsi_host_put(): decrements 1 from the reference count of the given
@@ -341,12 +341,12 @@ in parallel by these functions.
 Conventions
 ===========
 First, Linus Torvalds's thoughts on C coding style can be found in the
-Documentation/CodingStyle file. 
+Documentation/CodingStyle file.
 
-Next, there is a movement to "outlaw" typedefs introducing synonyms for 
+Next, there is a movement to "outlaw" typedefs introducing synonyms for
 struct tags. Both can be still found in the SCSI subsystem, but
 the typedefs have been moved to a single file, scsi_typedefs.h to
-make their future removal easier, for example: 
+make their future removal easier, for example:
 "typedef struct scsi_cmnd Scsi_Cmnd;"
 
 Also, most C99 enhancements are encouraged to the extent they are supported
@@ -364,7 +364,7 @@ and Adaptec have their own coding conven
 Mid level supplied functions
 ============================
 These functions are supplied by the SCSI mid level for use by LLDs.
-The names (i.e. entry points) of these functions are exported 
+The names (i.e. entry points) of these functions are exported
 so an LLD that is a module can access them. The kernel will
 arrange for the SCSI mid level to be loaded and initialized before any LLD
 is initialized. The functions below are listed alphabetically and their
@@ -387,7 +387,7 @@ Summary:
    scsi_remove_host - detach and remove all SCSI devices owned by host
    scsi_report_bus_reset - report scsi _bus_ reset observed
    scsi_scan_host - scan SCSI bus
-   scsi_track_queue_full - track successive QUEUE_FULL events 
+   scsi_track_queue_full - track successive QUEUE_FULL events
    scsi_unblock_requests - allow further commands to be queued to given host
    scsi_unregister - [calls scsi_host_put()]
 
@@ -419,7 +419,7 @@ void scsi_activate_tcq(struct scsi_devic
  * @id:      target id number
  * @lun:     logical unit number
  *
- *      Returns pointer to new struct scsi_device instance or 
+ *      Returns pointer to new struct scsi_device instance or
  *      ERR_PTR(-ENODEV) (or some other bent pointer) if something is
  *      wrong (e.g. no lu responds at given address)
  *
@@ -434,7 +434,7 @@ void scsi_activate_tcq(struct scsi_devic
  *
  *      Defined in: drivers/scsi/scsi_scan.c
  **/
-struct scsi_device * scsi_add_device(struct Scsi_Host *shost, 
+struct scsi_device * scsi_add_device(struct Scsi_Host *shost,
                                      unsigned int channel,
                                      unsigned int id, unsigned int lun)
 
@@ -483,7 +483,7 @@ int scsi_add_host(struct Scsi_Host *shos
  *      Defined in: drivers/scsi/scsi.c [see source code for more notes]
  *
  **/
-void scsi_adjust_queue_depth(struct scsi_device * sdev, int tagged, 
+void scsi_adjust_queue_depth(struct scsi_device * sdev, int tagged,
                              int tags)
 
 
@@ -546,7 +546,7 @@ void scsi_deactivate_tcq(struct scsi_dev
  *
  *      Notes: When this call returns to the LLD, the SCSI bus scan on
  *      this host has _not_ yet been done.
- *      The hostdata array (by default zero length) is a per host scratch 
+ *      The hostdata array (by default zero length) is a per host scratch
  *      area for the LLD's exclusive use.
  *      Both associated refcounting objects have their refcount set to 1.
  *      Full registration (in sysfs) and a bus scan are performed later when
@@ -624,7 +624,7 @@ int scsi_partsize(unsigned char *buf, un
  *
  *      Notes: When this call returns to the LLD, the SCSI bus scan on
  *      this host has _not_ yet been done.
- *      The hostdata array (by default zero length) is a per host scratch 
+ *      The hostdata array (by default zero length) is a per host scratch
  *      area for the LLD.
  *
  *      Defined in: drivers/scsi/hosts.c .
@@ -644,7 +644,7 @@ struct Scsi_Host * scsi_register(struct 
  *      Notes: If an LLD becomes aware that a scsi device (lu) has
  *      been removed but its host is still present then it can request
  *      the removal of that scsi device. If successful this call will
- *      lead to the slave_destroy() callback being invoked. sdev is an 
+ *      lead to the slave_destroy() callback being invoked. sdev is an
  *      invalid pointer after this call.
  *
  *      Defined in: drivers/scsi/scsi_sysfs.c .
@@ -661,7 +661,7 @@ int scsi_remove_device(struct scsi_devic
  *      Might block: yes
  *
  *      Notes: Should only be invoked if the "hotplug initialization
- *      model" is being used. It should be called _prior_ to  
+ *      model" is being used. It should be called _prior_ to
  *      scsi_unregister().
  *
  *      Defined in: drivers/scsi/hosts.c .
@@ -679,8 +679,8 @@ int scsi_remove_host(struct Scsi_Host *s
  *      Might block: no
  *
  *      Notes: This only needs to be called if the reset is one which
- *      originates from an unknown location.  Resets originated by the 
- *      mid level itself don't need to call this, but there should be 
+ *      originates from an unknown location.  Resets originated by the
+ *      mid level itself don't need to call this, but there should be
  *      no harm.  The main purpose of this is to make sure that a
  *      CHECK_CONDITION is properly treated.
  *
@@ -718,7 +718,7 @@ void scsi_scan_host(struct Scsi_Host *sh
  *      Might block: no
  *
  *      Notes: LLDs may call this at any time and we will do "The Right
- *              Thing"; interrupt context safe. 
+ *              Thing"; interrupt context safe.
  *
  *      Defined in: drivers/scsi/scsi.c .
  **/
@@ -765,7 +765,7 @@ Interface functions are supplied (define
 pointers are placed in an instance of struct scsi_host_template which
 is passed to scsi_host_alloc() [or scsi_register() / init_this_scsi_driver()].
 Some are mandatory. Interface functions should be declared static. The
-accepted convention is that driver "xyz" will declare its slave_configure() 
+accepted convention is that driver "xyz" will declare its slave_configure()
 function as:
     static int xyz_slave_configure(struct scsi_device * sdev);
 and so forth for all interface functions listed below.
@@ -794,7 +794,7 @@ Summary:
    proc_info - supports /proc/scsi/{driver_name}/{host_no}
    queuecommand - queue scsi command, invoke 'done' on completion
    release - release all resources associated with given host
-   slave_alloc - prior to any commands being sent to a new device 
+   slave_alloc - prior to any commands being sent to a new device
    slave_configure - driver fine tuning for given device after attach
    slave_destroy - given device is about to be shut down
 
@@ -803,14 +803,14 @@ Details:
 
 /**
  *      bios_param - fetch head, sector, cylinder info for a disk
- *      @sdev: pointer to scsi device context (defined in 
+ *      @sdev: pointer to scsi device context (defined in
  *             include/scsi/scsi_device.h)
  *      @bdev: pointer to block device context (defined in fs.h)
  *      @capacity:  device size (in 512 byte sectors)
  *      @params: three element array to place output:
  *              params[0] number of heads (max 255)
  *              params[1] number of sectors (max 63)
- *              params[2] number of cylinders 
+ *              params[2] number of cylinders
  *
  *      Return value is ignored
  *
@@ -820,7 +820,7 @@ Details:
  *
  *      Notes: an arbitrary geometry (based on READ CAPACITY) is used
  *      if this function is not provided. The params array is
- *      pre-initialized with made up values just in case this function 
+ *      pre-initialized with made up values just in case this function
  *      doesn't output anything.
  *
  *      Optionally defined in: LLD
@@ -842,7 +842,7 @@ Details:
  *
  *      Notes: First function called from the SCSI mid level on this
  *      driver. Upper level drivers (e.g. sd) may not (yet) be present.
- *      For each host found, this method should call scsi_register() 
+ *      For each host found, this method should call scsi_register()
  *      [see hosts.c].
  *
  *      Defined in: LLD (required if "passive initialization mode" is used,
@@ -942,10 +942,10 @@ Details:
  *      Calling context: kernel thread
  *
  *      Notes: Invoked from scsi_eh thread. No other commands will be
- *      queued on current host during eh. 
- *      With the default eh_strategy in place, if none of the _abort_, 
- *      _device_reset_, _bus_reset_ or this eh handler function are 
- *      defined (or they all return FAILED) then the device in question 
+ *      queued on current host during eh.
+ *      With the default eh_strategy in place, if none of the _abort_,
+ *      _device_reset_, _bus_reset_ or this eh handler function are
+ *      defined (or they all return FAILED) then the device in question
  *      will be set offline whenever eh is invoked.
  *
  *      Optionally defined in: LLD
@@ -968,7 +968,7 @@ Details:
  *
  *      Notes: Often supplies PCI or ISA information such as IO addresses
  *      and interrupt numbers. If not supplied struct Scsi_Host::name used
- *      instead. It is assumed the returned information fits on one line 
+ *      instead. It is assumed the returned information fits on one line
  *      (i.e. does not included embedded newlines).
  *      The SCSI_IOCTL_PROBE_HOST ioctl yields the string returned by this
  *      function (or struct Scsi_Host::name if this function is not
@@ -1039,7 +1039,7 @@ Details:
  *
  *      Optionally defined in: LLD
  **/
-    int proc_info(char * buffer, char ** start, off_t offset, 
+    int proc_info(char * buffer, char ** start, off_t offset,
                   int length, int host_no, int writeto1_read0)
 
 
@@ -1093,22 +1093,22 @@ Details:
  *      Calling context: in interrupt (soft irq) or process context
  *
  *      Notes: This function should be relatively fast. Normally it will
- *      not wait for IO to complete. Hence the 'done' callback is invoked 
+ *      not wait for IO to complete. Hence the 'done' callback is invoked
  *      (often directly from an interrupt service routine) some time after
- *      this function has returned. In some cases (e.g. pseudo adapter 
+ *      this function has returned. In some cases (e.g. pseudo adapter
  *      drivers that manufacture the response to a SCSI INQUIRY)
  *      the 'done' callback may be invoked before this function returns.
  *      If the 'done' callback is not invoked within a certain period
  *      the SCSI mid level will commence error processing.
  *      If a status of CHECK CONDITION is placed in "result" when the
- *      'done' callback is invoked, then the LLD driver should 
+ *      'done' callback is invoked, then the LLD driver should
  *      perform autosense and fill in the struct scsi_cmnd::sense_buffer
  *      array. The scsi_cmnd::sense_buffer array is zeroed prior to
  *      the mid level queuing a command to an LLD.
  *
  *      Defined in: LLD
  **/
-    int queuecommand(struct scsi_cmnd * scp, 
+    int queuecommand(struct scsi_cmnd * scp,
                      void (*done)(struct scsi_cmnd *))
 
 
@@ -1123,7 +1123,7 @@ Details:
  *      Calling context: process
  *
  *      Notes: Invoked from scsi_module.c's exit_this_scsi_driver().
- *      LLD's implementation of this function should call 
+ *      LLD's implementation of this function should call
  *      scsi_unregister(shp) prior to returning.
  *      Only needed for old-style host templates.
  *
@@ -1134,7 +1134,7 @@ Details:
 
 
 /**
- *      slave_alloc -   prior to any commands being sent to a new device 
+ *      slave_alloc -   prior to any commands being sent to a new device
  *                      (i.e. just prior to scan) this call is made
  *      @sdp: pointer to new device (about to be scanned)
  *
@@ -1266,7 +1266,7 @@ of interest:
                    (if any). FC and SPI transports currently supported.
     sh_list      - a double linked list of pointers to all struct Scsi_Host
                    instances (currently ordered by ascending host_no)
-    my_devices   - a double linked list of pointers to struct scsi_device 
+    my_devices   - a double linked list of pointers to struct scsi_device
                    instances that belong to this host.
     hostdata[0]  - area reserved for LLD at end of struct Scsi_Host. Size
                    is set by the second argument (named 'xtr_bytes') to
@@ -1340,7 +1340,7 @@ Members of interest:
                    underruns (overruns should be rare). If possible an LLD
                    should set 'resid' prior to invoking 'done'. The most
                    interesting case is data transfers from a SCSI target
-                   device device (i.e. READs) that underrun. 
+                   device device (i.e. READs) that underrun.
     underflow    - LLD should place (DID_ERROR << 16) in 'result' if
                    actual number of bytes transferred is less than this
                    figure. Not many LLDs implement this check and some that
@@ -1353,8 +1353,8 @@ The scsi_cmnd structure is defined in in
 
 Locks
 =====
-Each struct Scsi_Host instance has a spin_lock called struct 
-Scsi_Host::default_lock which is initialized in scsi_host_alloc() [found in 
+Each struct Scsi_Host instance has a spin_lock called struct
+Scsi_Host::default_lock which is initialized in scsi_host_alloc() [found in
 hosts.c]. Within the same function the struct Scsi_Host::host_lock pointer
 is initialized to point at default_lock.  Thereafter lock and unlock
 operations performed by the mid level use the struct Scsi_Host::host_lock
@@ -1368,13 +1368,13 @@ Autosense (or auto-sense) is defined in 
 automatic return of sense data to the application client coincident
 with the completion of a SCSI command" when a status of CHECK CONDITION
 occurs. LLDs should perform autosense. This should be done when the LLD
-detects a CHECK CONDITION status by either: 
+detects a CHECK CONDITION status by either:
     a) instructing the SCSI protocol (e.g. SCSI Parallel Interface (SPI))
        to perform an extra data in phase on such responses
     b) or, the LLD issuing a REQUEST SENSE command itself
 
 Either way, when a status of CHECK CONDITION is detected, the mid level
-decides whether the LLD has performed autosense by checking struct 
+decides whether the LLD has performed autosense by checking struct
 scsi_cmnd::sense_buffer[0] . If this byte has an upper nibble of 7 (or 0xf)
 then autosense is assumed to have taken place. If it has another value (and
 this byte is initialized to 0 before each command) then the mid level will
@@ -1388,7 +1388,7 @@ to perform autosense.
 
 Changes since lk 2.4 series
 ===========================
-io_request_lock has been replaced by several finer grained locks. The lock 
+io_request_lock has been replaced by several finer grained locks. The lock
 relevant to LLDs is struct Scsi_Host::host_lock and there is
 one per SCSI host.
 
@@ -1396,9 +1396,9 @@ The older error handling mechanism has b
 LLD interface functions abort() and reset() have been removed.
 The struct scsi_host_template::use_new_eh_code flag has been removed.
 
-In the 2.4 series the SCSI subsystem configuration descriptions were 
-aggregated with the configuration descriptions from all other Linux 
-subsystems in the Documentation/Configure.help file. In the 2.6 series, 
+In the 2.4 series the SCSI subsystem configuration descriptions were
+aggregated with the configuration descriptions from all other Linux
+subsystems in the Documentation/Configure.help file. In the 2.6 series,
 the SCSI subsystem now has its own (much smaller) drivers/scsi/Kconfig
 file that contains both configuration and help information.
 
@@ -1413,7 +1413,7 @@ Credits
 The following people have contributed to this document:
         Mike Anderson <andmike at us dot ibm dot com>
         James Bottomley <James dot Bottomley at hansenpartnership dot com>
-        Patrick Mansfield <patmans at us dot ibm dot com> 
+        Patrick Mansfield <patmans at us dot ibm dot com>
         Christoph Hellwig <hch at infradead dot org>
         Doug Ledford <dledford at redhat dot com>
         Andries Brouwer <Andries dot Brouwer at cwi dot nl>
--- linux-2.6.33-rc4-git2.orig/Documentation/scsi/scsi-generic.txt
+++ linux-2.6.33-rc4-git2/Documentation/scsi/scsi-generic.txt
@@ -18,7 +18,7 @@ and examples.
 Major versions of the sg driver
 ===============================
 There are three major versions of sg found in the linux kernel (lk):
-      - sg version 1 (original) from 1992 to early 1999 (lk 2.2.5) . 
+      - sg version 1 (original) from 1992 to early 1999 (lk 2.2.5) .
 	It is based in the sg_header interface structure.
       - sg version 2 from lk 2.2.6 in the 2.2 series. It is based on
 	an extended version of the sg_header interface structure.
@@ -29,28 +29,28 @@ There are three major versions of sg fou
 Sg driver documentation
 =======================
 The most recent documentation of the sg driver is kept at the Linux
-Documentation Project's (LDP) site: 
+Documentation Project's (LDP) site:
 http://www.tldp.org/HOWTO/SCSI-Generic-HOWTO
 This describes the sg version 3 driver found in the lk 2.4 series.
 The LDP renders documents in single and multiple page HTML, postscript
 and pdf. This document can also be found at:
-http://www.torque.net/sg/p/sg_v3_ho.html
+http://sg.danny.cz/sg/p/sg_v3_ho.html
 
 Documentation for the version 2 sg driver found in the lk 2.2 series can
-be found at http://www.torque.net/sg/p/scsi-generic.txt . A larger version
-is at:  http://www.torque.net/sg/p/scsi-generic_long.txt .
+be found at http://sg.danny.cz/sg/p/scsi-generic.txt . A larger version
+is at:  http://sg.danny.cz/sg/p/scsi-generic_long.txt .
 
 The original documentation for the sg driver (prior to lk 2.2.6) can be
-found at http://www.torque.net/sg/p/original/SCSI-Programming-HOWTO.txt
+found at http://sg.danny.cz/sg/p/original/SCSI-Programming-HOWTO.txt
 and in the LDP archives.
 
 A changelog with brief notes can be found in the
-/usr/src/linux/include/scsi/sg.h file. Note that the glibc maintainers copy 
-and edit this file (removing its changelog for example) before placing it 
-in /usr/include/scsi/sg.h . Driver debugging information and other notes 
+/usr/src/linux/include/scsi/sg.h file. Note that the glibc maintainers copy
+and edit this file (removing its changelog for example) before placing it
+in /usr/include/scsi/sg.h . Driver debugging information and other notes
 can be found at the top of the /usr/src/linux/drivers/scsi/sg.c file.
 
-A more general description of the Linux SCSI subsystem of which sg is a 
+A more general description of the Linux SCSI subsystem of which sg is a
 part can be found at http://www.tldp.org/HOWTO/SCSI-2.4-HOWTO .
 
 
@@ -60,8 +60,8 @@ There are two packages of sg utilities:
   - sg3_utils   for the sg version 3 driver found in lk 2.4
   - sg_utils    for the sg version 2 (and original) driver found in lk 2.2
                 and earlier
-Both packages will work in the lk 2.4 series however sg3_utils offers more
-capabilities. They can be found at: http://www.torque.net/sg and 
+Both packages will work in the lk 2.4 series; however, sg3_utils offers more
+capabilities. They can be found at: http://sg.danny.cz/sg/index.html and
 freshmeat.net
 
 Another approach is to look at the applications that use the sg driver.
@@ -73,14 +73,14 @@ Mapping of Linux kernel versions to sg d
 Here is a list of linux kernels in the 2.4 series that had new version
 of the sg driver:
       lk 2.4.0 : sg version 3.1.17
-      lk 2.4.7 : sg version 3.1.19 
+      lk 2.4.7 : sg version 3.1.19
       lk 2.4.10 : sg version 3.1.20  **
-      lk 2.4.17 : sg version 3.1.22 
+      lk 2.4.17 : sg version 3.1.22
 
 ** There were 3 changes to sg version 3.1.20 by third parties in the
    next six linux kernel versions.
 
-For reference here is a list of linux kernels in the 2.2 series that had 
+For reference here is a list of linux kernels in the 2.2 series that had
 new version of the sg driver:
       lk 2.2.0 : original sg version [with no version number]
       lk 2.2.6 : sg version 2.1.31
