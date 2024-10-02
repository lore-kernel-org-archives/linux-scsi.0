Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20608F40
	for <linux-scsi@vger.kernel.org>; Wed,  2 Oct 2024 20:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727901375; cv=none; b=UnQ5n2Sp8TKKW98f0pNvuzZaQ8rYw5fKlnyuMkRBfGIFMX50iq6kk/W952QptHaqjBt//MNpql4IOTKWjAVpYh2AxkyBHUygPlJW0IcHUngn/2R4UCjUQ/np5hXbP3vbuPK2plRb1UEbhAx6m90AMk+u0KC5l/M/SG8/l/orynE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727901375; c=relaxed/simple;
	bh=jJ5qodNzpkPIYeBsZBzV1pJZstt5ML9c3rFsh6kh+eA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oTjEf+PmahavgPC+o0laVT/V2Q4kLCJQ5ZjBw4+O5+22xJp5rwM1lc32VDI77NeDiWFjj3g8OIHL2S4A+ztVCrkmsPhwqZl/KZX0Igg5TYTF2+Td+B70KZQCIE2eBA7cJVFMrj3SIy0+oTkCGELIEmTiR9Mno2KFNw3bBUQWQQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=G4H2XfOR; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="G4H2XfOR"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XJmmX3sjJzlgMWB;
	Wed,  2 Oct 2024 20:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1727901363; x=1730493364; bh=D4Gkg
	oDMN59t7/YSpRslPGUJtyyXY7l/WKOULpGif9k=; b=G4H2XfORAs+EPTN4GfOZi
	5R/tDrBthJdMuEEWf+ONENsF9zlWpHPpOv7D/twDZ9cbvV77wnR9s0zIbXrsyK+K
	xWHYgFumMuKyp3QaHrn+CLP3pSajM62I+n6aNLfogrGs2hd3jULfZ7aSCm8rKnJQ
	+7jTj6HxjHj6D/m8aDkHIemyrqjPsaacVNXFltO2WvkdOn4XUQhXBQIWJAd/3LeU
	xi50KdYVVzTSls8UrSqrZcp03oBklF07UWBtSyFRjOLZFraL3b9abRhflpBCVTWN
	hCq8xgYyKYfFUsSgUa4HJVNHh8lssXAVhNwo+3B8Tzr0Q1SvWaMt3iWYC+nNkYVT
	g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id VnrL0FKKsVLX; Wed,  2 Oct 2024 20:36:03 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XJmmK4pwVzlgMWC;
	Wed,  2 Oct 2024 20:36:01 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v2 04/11] scsi: ncr53c8xx: Remove the changelog
Date: Wed,  2 Oct 2024 13:33:56 -0700
Message-ID: <20241002203528.4104996-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.1.824.gd892dcdcdd-goog
In-Reply-To: <20241002203528.4104996-1-bvanassche@acm.org>
References: <20241002203528.4104996-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Since we typically do not maintain changelogs as text files in the Linux
kernel, and since the ncr53c8xx changelog has not been updated since 2002=
,
remove it.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 Documentation/scsi/ChangeLog.ncr53c8xx | 495 -------------------------
 1 file changed, 495 deletions(-)
 delete mode 100644 Documentation/scsi/ChangeLog.ncr53c8xx

diff --git a/Documentation/scsi/ChangeLog.ncr53c8xx b/Documentation/scsi/=
ChangeLog.ncr53c8xx
deleted file mode 100644
index 50bf850da838..000000000000
--- a/Documentation/scsi/ChangeLog.ncr53c8xx
+++ /dev/null
@@ -1,495 +0,0 @@
-Sat May 12 12:00 2001 Gerard Roudier (groudier@club-internet.fr)
-	* version ncr53c8xx-3.4.3b
-	- Ensure LEDC bit in GPCNTL is cleared when reading the NVRAM.
-	  Fix sent by Stig Telfer <stig@api-networks.com>.
-	- Define scsi_set_pci_device() as nil for kernel < 2.4.4.
-
-Mon Feb 12 22:30 2001 Gerard Roudier (groudier@club-internet.fr)
-	* version ncr53c8xx-3.4.3
-	- Call pci_enable_device() as AC wants this to be done.
-	- Get both the BAR cookies actual and PCI BAR values.
-	  (see Changelog.sym53c8xx rev. 1.7.3 for details)
-	- Merge changes for linux-2.4 that declare the host template=20
-	  in the driver object also when the driver is statically=20
-	  linked with the kernel.
-
-Sun Sep 24 21:30 2000 Gerard Roudier (groudier@club-internet.fr)
-	* version ncr53c8xx-3.4.2
-	- See Changelog.sym53c8xx, driver version 1.7.2.
-
-Wed Jul 26 23:30 2000 Gerard Roudier (groudier@club-internet.fr)
-	* version ncr53c8xx-3.4.1
-	- Provide OpenFirmware path through the proc FS on PPC.
-	- Remove trailing argument #2 from a couple of #undefs.
-
-Sun Jul 09 16:30 2000 Gerard Roudier (groudier@club-internet.fr)
-	* version ncr53c8xx-3.4.0
-	- Remove the PROFILE C and SCRIPTS code.
-	  This facility was not this useful and thus was not longer=20
-	  desirable given the increasing complexity of the driver code.
-	- Merges from FreeBSD sym-1.6.2 driver:
-	  * Clarify memory barriers needed by the driver for architectures=20
-	    that implement a weak memory ordering.
-	- General cleanup:
-	  Move definitions for barriers and IO/MMIO operations to the=20
-	  sym53c8xx_defs.h header files. They are now shared by the=20
-	  both drivers.
-	  Use SCSI_NCR_IOMAPPED instead of NCR_IOMAPPED.
-
-Thu May 11   12:30 2000 Pam Delaney (pam.delaney@lsil.com)
-	* revision 3.3b
-=20
-Mon Apr 24 12:00 2000 Gerard Roudier (groudier@club-internet.fr)
-	* revision 3.2i
-	- Return value 1 (instead of 0) from the driver setup routine.
-	- Let the driver also attach controllers that have been set to=20
-	  OFF in the NVRAM as it did prior to revision 3.2g.
-
-Sat Apr 1  12:00 2000 Gerard Roudier (groudier@club-internet.fr)
-	* revision 3.2h
-	- Fix a compilation problem on Alpha introduced in version 3.2g.
-          (`port' changed to `base_io').
-	- Move from `sym' to this driver a tiny change for __sparc__ that=20
-	  applies to cache line size (? Probably from David S Miller).
-	- Make sure no data transfer will happen for Scsi_Cmnd requests=20
-	  that supply SCSI_DATA_NONE direction (this avoids some BUG()=20
-	  statement in the PCI code when a data buffer is also supplied).
-
-Thu Mar 16   9:30 2000 Pam Delaney (pam.delaney@lsil.com)
-	* revision 3.3b-3
- 	- Added exclusion for the 53C1010 and 53C1010_66 chips
-	  to the driver (change to sym53c8xx_comm.h).
-
-Mon March 6  23:15 2000 Gerard Roudier (groudier@club-internet.fr)
-	* revision 3.2g
-	- Add the file sym53c8xx_comm.h that collects code that should=20
-	  be shared by sym53c8xx and ncr53c8xx drivers. For now, it is =20
-	  a header file that is only included by the ncr53c8xx driver,=20
-	  but things will be cleaned up later. This code addresses=20
-	  notably:
-	  * Chip detection and PCI related initialisations
-	  * NVRAM detection and reading
-	  * DMA mapping
-	  * Boot setup command
-	  * And some other ...
-	- Add support for the new dynamic dma mapping kernel interface.
-	  Requires Linux-2.3.47 (tested with pre-2.3.47-6).
-	- Get data transfer direction from the scsi command structure=20
-	  (Scsi_Cmnd) when this information is available.
-
-Mon March 6  23:15 2000 Gerard Roudier (groudier@club-internet.fr)
-        * revision 3.2g
-        - Add the file sym53c8xx_comm.h that collects code that should
-          be shared by sym53c8xx and ncr53c8xx drivers. For now, it is
-          a header file that is only included by the ncr53c8xx driver,
-          but things will be cleaned up later. This code addresses
-          notably:
-          * Chip detection and PCI related initialisations
-          * NVRAM detection and reading
-          * DMA mapping
-          * Boot setup command
-          * And some other ...
-        - Add support for the new dynamic dma mapping kernel interface.
-          Requires Linux-2.3.47 (tested with pre-2.3.47-6).
-        - Get data transfer direction from the scsi command structure
-          (Scsi_Cmnd) when this information is available.
-
-Fri Jan 14 14:00 2000 Pam Delaney (pam.delaney@lsil.com)
-	* revision pre-3.3b-1
-	- Merge parallel driver series 3.31 and 3.2e=20
-
-Tue Jan 11 14:00 2000 Pam Delaney (pam.delaney@lsil.com)
-	* revision 3.31
-	- Added support for mounting disks on wide-narrow-wide
-	  scsi configurations. =20
-	- Built off of version 3.30
-
-Mon Jan 10 13:30 2000 Pam Delaney (pam.delaney@lsil.com)
-	* revision 3.30
-	- Added capability to use the integrity checking code
-	  in the kernel (optional).
-	- Disabled support for the 53C1010.
-	- Built off of version 3.2c
-
-Sat Jan 8  22:00 2000 Gerard Roudier (groudier@club-internet.fr)
-	* revision 3.2e
-	- Add year 2000 copyright.
-	- Display correctly bus signals when bus is detected wrong.
-	- Remove the dead code that broke driver 3.2d.
-
-Mon Dec 6  22:00 1999 Gerard Roudier (groudier@club-internet.fr)
-	* revision 3.2d
-	- Change messages written by the driver at initialisation and=20
-	  through the /proc FS (rather cosmetic changes that consist in
-	  printing out the PCI bus number and device/function).
-	- Get rid of the old PCI bios interface, but preserve kernel 2.0=20
-	  compatibility from a simple wrapper.
-	- Remove the compilation condition about having to acquire the=20
-	  io_request_lock since it seems to be a definite feature now.:)
-	- proc_dir structure no longer needed for kernel >=3D 2.3.27.
-	- Change the driver detection code by the sym53c8xx one, modulo=20
-	  some minor changes. The driver can now attach any number of=20
-	  controllers (>40) and does no longer hoger stack space at=20
-	  initialisation.
-	- Definitely disable overlapped PCI arbitration for all dual=20
-	  function chips, since I cannot make sure for what chip revisions=20
-	  it is actually safe.
-	- Add support for the SYM53C1510D.
-	- Update the poor Tekram sync factor table.
-	- Remove the compilation condition about having to acquire the=20
-	  io_request_lock since it seems to be a definite feature now.:)
-	- proc_dir structure no longer needed for kernel >=3D 2.3.27.
-
-Sat Sep 11  18:00 1999 Gerard Roudier (groudier@club-internet.fr)
-	* revision 3.2c
-	- Handle correctly (hopefully) jiffies wrap-around.
-	- Restore the entry used to detect 875 until revision 0xff.
-	  (I removed it inadvertently, it seems :) )
-	- Replace __initfunc() which is deprecated stuff by __init which=20
-	  is not yet so. ;-)
-	- Add support of some 'resource handling' for linux-2.3.13.
-	  Basically the BARs have been changed to something more complex=20
-	  in the pci_dev structure.
-	- Remove some deprecated code.
-
-Sat May 10  11:00 1999 Gerard Roudier (groudier@club-internet.fr)
-	* revision pre-3.2b-1
-	- Support for the 53C895A by Pamela Delaney <pam.delaney@lsil.com>
-	  The 53C895A contains all of the features of the 896 but has only=20
-	  one channel and has a 32 bit PCI bus. It does 64 bit PCI addressing=20
-	  using dual cycle PCI data transfers.
-	- Miscellaneous minor fixes.
-	- Some additions to the README.ncr53c8xx file.
-
-Sun Apr 11  10:00 1999 Gerard Roudier (groudier@club-internet.fr)
-	* revision 3.2a
-	- Add 'hostid:#id' boot option. This option allows to change the=20
-	  default SCSI id the driver uses for controllers.
-	- Remove nvram layouts and driver set-up structures from the C source,
-	  and use the one defined in sym53c8xx_defs.h file.
-	  (shared by both drivers).
-	- Set for now MAX LUNS to 16 (instead of 8).
-
-Thu Mar 11  23:00 1999 Gerard Roudier (groudier@club-internet.fr)
-	* revision 3.2	  (8xx-896 driver bundle)
-	- Only define the host template in ncr53c8xx.h and include the=20
-	  sym53c8xx_defs.h file.
-	- Declare static all symbols that do not need to be visible from=20
-	  outside the driver code.
-	- Add 'excl' boot command option that allows to pass to the driver=20
-	  io address of devices not to attach.
-	- Add info() function called from the host template to print=20
-	  driver/host information.
-	- Minor documentation additions.
-
-Sat Mar 6  11:00 1999 Gerard Roudier (groudier@club-internet.fr)
-	* revision 3.1h
-	- Fix some oooold bug that hangs the bus if a device rejects a=20
-	  negotiation. Btw, the corresponding stuff also needed some cleanup=20
-	  and thus the change is a bit larger than it could have been.
-	- Still some typo that made compilation fail for 64 bit (trivial fix).
-
-Sun Feb  14:00 1999 Gerard Roudier (groudier@club-internet.fr)
-	* revision 3.1g
-	- Deal correctly with 64 bit PCI address registers on Linux 2.2.
-	  Pointed out by Leonard Zubkoff.
-	- Allow to tune request_irq() flags from the boot command line using=20
-	  ncr53c8xx=3Dirqm:??, as follows:
-	  a) If bit 0x10 is set in irqm, IRQF_SHARED flag is not used.
-	  b) If bit 0x20 is set in irqm, IRQF_DISABLED flag is not used.
-	  By default the driver uses both IRQF_SHARED and IRQF_DISABLED.
-	  Option 'ncr53c8xx=3Dirqm:0x20' may be used when an IRQ is shared by=20
-	  a 53C8XX adapter and a network board.
-	- Tiny misspelling fixed (ABORT instead of ABRT). Was fortunately=20
-	  harmless.
-	- Negotiate SYNC data transfers with CCS devices.
-
-Sat Jan 16  17:30 1999 Gerard Roudier (groudier@club-internet.fr)
-	* revision 3.1f
-	- Some PCI fix-ups not needed any more for PPC (from Cort).
-	- Cache line size set to 16 DWORDS for Sparc   (from DSM).
-	- Waiting list look-up didn't work for the first command of the list.
-	- Remove 2 useless lines of code.
-
-Sun Dec 13  18:00 1998 Gerard Roudier (groudier@club-internet.fr)
-	* revision 3.1e
-	- Same work-around as for the 53c876 rev <=3D 0x15 for 53c896 rev 1:
-	  Disable overlapped arbitration. This will not make difference=20
-	  since the chip has on-chip RAM.
-
-Thu Nov 26  22:00 1998 Gerard Roudier (groudier@club-internet.fr)
-	* revision 3.1d
-	- The SISL RAID change requires now remap_pci_mem() stuff to be=20
-	  compiled for __i386__ when normal IOs are used.
-	- Minor spelling fixes in doc files.
-
-Sat Nov 21  18:00 1998 Gerard Roudier (groudier@club-internet.fr)
-	* revision 3.1c
-	- Ignore chips that are driven by SISL RAID (DAC 960).
-	  Change sent by Leonard Zubkoff and slightly reworked.
-	- Still a buglet in the tags initial settings that needed to be fixed.
-	  It was not possible to disable TGQ at system startup for devices=20
-	  that claim TGQ support. The driver used at least 2 for the queue=20
-	  depth but didn't keep track of user settings for tags depth lower
-	  than 2.
-
-Wed Nov 11  10:00 1998 Gerard Roudier (groudier@club-internet.fr)
-	* revision 3.1b
-	- The driver was unhappy when configured with default_tags > MAX_TAGS
-	  Hopefully doubly-fixed.
-	- Update the Configure.help driver section that speaks of TAGS.
-
-Wed Oct 21 21:00 1998 Gerard Roudier (groudier@club-internet.fr)
-	* revision 3.1a
-	- Changes from Eddie Dost for Sparc and Alpha:
-	  ioremap/iounmap support for Sparc.
-	  pcivtophys changed to bus_dvma_to_phys.
-	- Add the 53c876 description to the chip table. This is only useful=20
-	  for printing the right name of the controller.
-	- DEL-441 Item 2 work-around for the 53c876 rev <=3D 5 (0x15).
-	- Add additional checking of INQUIRY data:
-	  Check INQUIRY data received length is at least 7. Byte 7 of=20
-	  inquiry data contains device features bits and the driver might=20
-	  be confused by garbage. Also check peripheral qualifier.
-	- Cleanup of the SCSI tasks management:
-	  Remove the special case for 32 tags. Now the driver only uses the=20
-	  scheme that allows up to 64 tags per LUN.
-	  Merge some code from the 896 driver.
-	  Use a 1,3,5,...MAXTAGS*2+1 tag numbering. Previous driver could =20
-	  use any tag number from 1 to 253 and some non conformant devices =20
-	  might have problems with large tag numbers.
-	- 'no_sync' changed to 'no_disc' in the README file. This is an old=20
-	  and trivial mistake that seems to demonstrate the README file is=20
-	  not often read. :)
-
-Sun Oct  4 14:00 1998 Gerard Roudier (groudier@club-internet.fr)
-	* revision 3.0i
-	- Cosmetic changes for sparc (but not for the driver) that needs =20
-	  __irq_itoa() to be used for printed IRQ value to be understandable.
-	- Some problems with the driver that didn't occur using driver 2.5f=20
-	  were due to a SCSI selection problem triggered by a clearly=20
-	  documented feature that in fact seems not to work: (53C8XX chips =20
-	  are claimed by the manuals to be able to execute SCSI scripts just=20
-	  after arbitration while the SCSI core is performing SCSI selection).
-	  This optimization is broken and has been removed.
-	- Some broken scsi devices are confused when a negotiation is started=20
-	  on a LUN that does not correspond to a real device. According to=20
-	  SCSI specs, this is a device firmware bug. This has been worked=20
-	  around by only starting negotiation if the LUN has previously be=20
-	  used for at least 1 successful SCSI command.
-	- The 'last message sent' printed out on M_REJECT message reception=20
-	  was read from the SFBR i/o register after the previous message had=20
-	  been sent.=20
-	  This was not correct and affects all previous driver versions and=20
-	  the original FreeBSD one as well. The SCSI scripts has been fixed=20
-	  so that it now provides the right information to the C code.
-
-Sat Jul 18 13:00 1998 Gerard Roudier (groudier@club-internet.fr)
-	* revision 3.0g
-	- Preliminary fixes for Big Endian (sent by Eddie C. Dost).
-	  Big Endian architectures should work again with the driver.
-	  Eddie's patch has been partially applied since current 2.1.109=20
-	  does not have all the Sparc changes of the vger tree.
-	- Use of BITS_PER_LONG instead of (~0UL =3D=3D 0xffffffffUL) has fixed
-	  the problem observed when the driver was compiled using EGCS or=20
-	  PGCC.
-
-Mon Jul 13 20:00 1998 Gerard Roudier (groudier@club-internet.fr)
-	* revision 3.0f
-	- Some spelling fixes.
-	- linux/config.h misplaced in ncr53c8xx.h
-	- MODULE_PARM stuff added for linux 2.1.
-	- check INQUIRY response data format is exactly 2.=20
-	- use BITS_PER_LONG if defined.=20
-
-Sun Jun 28 12:00 1998 Gerard Roudier (groudier@club-internet.fr)
-	* revision 3.0e
-	- Some cleanup, spelling fixes, version checks, documentations=20
-	  changes, etc ...
-
-Sat Jun 20 20:00 1998 Gerard Roudier (groudier@club-internet.fr)
-	* revision 3.0c
-	- Add a boot setup option that allows to set up device queue depths=20
-	  at boot-up. This option is very useful since Linux does not=20
-	  allow to change scsi device queue depth once the system has been=20
-	  booted up.
-
-Sun Jun 15 23:00 1998 Gerard Roudier (groudier@club-internet.fr)
-	* revision 3.0a
-	- Support for up to 64 TAGS per LUN.
-	- Rewrite the TARGET vs LUN capabilities management.
-	  CmdQueue is now handled as a LUN capability as it shall be.
-	  This also fixes a bug triggered when disabling tagged command=20
-	  queuing for a device that had this feature enabled.
-	- Remove the ncr_opennings() stuff that was useless under Linux=20
-	  and hard to understand to me.
-	- Add "setverbose" procfs driver command. It allows to tune=20
-	  verbose level after boot-up. Setting this level to zero, for=20
-	  example avoid flooding the syslog file.
-	- Add KERN_XXX to some printk's.
-
-Tue Jun 10 23:00 1998 Gerard Roudier (groudier@club-internet.fr)
-	* revision 3.0
-	- Linux config changes for 2.0.34:
-	  Remove NVRAM detection config option. This option is now enabled=20
-	  by default but can be disabled by editing the driver header file.
-	  Add a PROFILE config option.
-	- Update Configure.help
-	- Add calls to new function mdelay() for milli-seconds delay if=20
-	  kernel version >=3D 2.1.105.
-	- Replace all printf(s) by printk(s). After all, the ncr53c8xx is=20
-	  a driver for Linux.
-	- Perform auto-sense on COMMAND TERMINATED. Not sure it is useful.
-	- Some other minor changes.
-
-Tue Jun 4 23:00 1998 Gerard Roudier (groudier@club-internet.fr)
-	* revision 2.6n
-	- Code cleanup and simplification:
-	  Remove kernel 1.2.X and 1.3.X support.
-	  Remove the _old_ target capabilities table.
-	  Remove the error recovery code that hasn't been really useful.
-	  Use a single alignment boundary (CACHE_LINE_SIZE) for data=20
-	  structures.
-	- Several aggressive SCRIPTS optimizations and changes:
-	  Reselect SCRIPTS code rewritten.
-	  Support for selection/reselection without ATN.
-	  And some others.
-	- Miscallaneous changes in the C code:
-	  Count actual number of CCB queued to the controller (future use).
-	  Lots of other minor changes.
-
-Wed May 13 20:00 1998 Gerard Roudier (groudier@club-internet.fr)
-	* revision 2.6m
-	- Problem of missed SCSI bus reset with the 53C895 fixed by=20
-	  Richard Waltham. The 53C895 needs about 650 us for the bus=20
-	  mode to settle. Delays used while resetting the controller=20
-	  and the bus have been adjusted. Thanks Richard!
-	- Some simplification for 64 bit arch done ccb address testing.
-	- Add a check of the MSG_OUT phase after Selection with ATN.
-	- The new tagged queue stuff seems ok, so some informationnal=20
-	  message have been conditioned by verbose >=3D 3.
-	- Do not reset if a SBMC interrupt reports the same bus mode.
-	- Print out the whole driver set-up. Some options were missing and=20
-	  the print statement was misplaced for modules.
-	- Ignore a SCSI parity interrupt if the chip is not connected to=20
-	  the SCSI bus.
-
-Sat May 1 16:00 1998 Gerard Roudier (groudier@club-internet.fr)
-	* revision 2.6l
-	- Add CCB done queue support for Alpha and perhaps some other=20
-	  architectures.
-	- Add some barriers to enforce memory ordering for x86 and=20
-	  Alpha architectures.
-	- Fix something that looks like an old bug in the nego SIR=20
-	  interrupt code in case of negotiation failure.
-
-Sat Apr 25 21:00 1998 Gerard Roudier (groudier@club-internet.fr)
-	* revision 2.6k
-	- Remove all accesses to the on-chip RAM from the C code:
-	  Use SCRIPTS to load the on-chip RAM.
-	  Use SCRIPTS to repair the start queue on selection timeout.
-	  Use the copy of script in main memory to calculate the chip=20
-	  context on phase mismatch.
-	- The above allows now to use the on-chip RAM without requiring=20
-	  to get access to the on-chip RAM from the C code. This makes=20
-	  on-chip RAM usable for linux-1.2.13 and for Linux-Alpha for
-	  instance.
-	- Some simplifications and cleanups in the SCRIPTS and C code.
-	- Buglet fixed in parity error recovery SCRIPTS (never tested).
-	- Minor updates in README.ncr53c8xx.
-
-Wed Apr 15 21:00 1998 Gerard Roudier (groudier@club-internet.fr)
-	* revision 2.6j
-	- Incorporate changes from linux-2.1.95 ncr53c8xx driver version.
-	- Add SMP support for linux-2.1.95 and above.
-	- Fix a bug when QUEUE FULL is returned and no commands are=20
-	  disconnected. This happens with Atlas I / L912 and may happen=20
-	  with Atlas II / LXY4.
-	- Nail another one on CHECK condition when requeuing the command=20
-	  for auto-sense.
-	- Call scsi_done() for all completed commands after interrupt=20
-	  handling.
-	- Increase the done queue to 24 entries.
-
-Sat Apr 4 20:00 1998 Gerard Roudier (groudier@club-internet.fr)
-	* revision 2.6i
-	- CTEST0 is used by the 53C885 for Power Management and=20
-	  priority setting between the 2 functions.
-	  Use SDID instead as actual target number. Just have had to=20
-	  overwrite it with SSID on reselection.
-	- Split DATA_IN and DATA_OUT scripts into 2 sub-scripts.
-	  64 segments are moved from on-chip RAM scripts.
-	  If more segments, a script in main memory is used for the=20
-	  additional segments.
-	- Since the SCRIPTS processor continues SCRIPTS execution after=20
-	  having won arbitration, do some stuff prior to testing any SCSI=20
-	  phase on reselection. This should have the vertue to process=20
-	  scripts in parallel with the SCSI core performing selection.
-	- Increase the done queue to 12 entries.
-
-Sun Mar 29 12:00 1998 Gerard Roudier (groudier@club-internet.fr)
-	* revision 2.6h
-	- Some fixes.
-
-Tue Mar 26 23:00 1998 Gerard Roudier (groudier@club-internet.fr)
-	* revision 2.6g
-	- New done queue. 8 entries by default (6 always usable).
-	  Can be increased if needed.
-	- Resources management using doubly linked queues.
-	- New auto-sense and QUEUE FULL handling that does not need to=20
-	  stall the NCR queue any more.
-	- New CCB starvation avoiding algorithm.
-	- Prepare CCBs for SCSI commands that cannot be queued, instead of=20
-	  inserting these commands into the waiting list. The waiting list=20
-	  is now only used while resetting and when memory for CCBs is not=20
-	  yet available?
-
-Sun Feb 8 22:00 1998 Gerard Roudier (groudier@club-internet.fr)
-	* revision 2.6f
-	- Some fixes in order to really support the 53C895, at least with=20
-	  FAST-20 devices.
-	- Heavy changes in the target/lun resources management to allow=20
-	  the scripts to jump directly to the CCB on reselection instead=20
-	  of walking on the lun CCBs list. Up to 32 tags per lun are now=20
-	  supported without script processor and PCI traffic overhead.
-
-Sun Jan 11 22:00 1998 Gerard Roudier (groudier@club-internet.fr)
-	* revision 2.6d
-	- new (different ?) implementation of the start queue:
-          Use a simple CALL to a launch script in the CCB.
-	- implement a minimal done queue (1 entry :-) ).
-          this avoid scanning all CCBs on INT FLY (Only scan all CCBs, o=
n=20
-          overflow). Hit ratio is better than 99.9 % on my system, so no=
=20
-          need to have a larger done queue.
-	- generalization of the restart of CCB on special condition as=20
-          Abort, QUEUE FULL, CHECK CONDITION.
-          This has been called 'silly scheduler'.
-	- make all the profiling code conditioned by a config option.
-	  This spare some PCI traffic and C code when this feature is not=20
-          needed.
-	- handle more cleanly the situation where direction is unknown.
-	  The pointers patching is now performed by the SCRIPTS processor.
-	- remove some useless scripts instructions.
-
-	Ported from driver 2.5 series:
-        ------------------------------
-	- Use FAST-5 instead of SLOW for slow scsi devices according to=20
-	  new SPI-2 draft.
-	- Make some changes in order to accommodate with 875 rev <=3D 3=20
-	  device errata listing 397. Minor consequences are:
-	  . Leave use of PCI Write and Invalidate under user control.
-	    Now, by default the driver does not enable PCI MWI and option
-	    'specf:y' is required in order to enable this feature.
-	  . Memory Read Line is not enabled for 875 and 875-like chips.
-	  . Programmed burst length set to 64 DWORDS (instead of 128).
-	    (Note: SYMBIOS uses 32 DWORDS for the SDMS BIOS)
-	- Add 'buschk' boot option.
-	  This option enables checking of SCSI BUS data lines after SCSI=20
-	  RESET (set by default). (Submitted by Richard Waltham).
-	- Update the README file.
-	- Dispatch CONDITION MET and RESERVATION CONFLICT scsi status=20
-	  as OK driver status.
-	- Update the README file and the Symbios NVRAM format definition=20
-	  with removable media flags values (available with SDMS 4.09).
-	- Several PCI configuration registers fix-ups for powerpc.
-	  (Patch sent by Cort).
