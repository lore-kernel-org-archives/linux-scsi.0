Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A33E8F40
	for <linux-scsi@vger.kernel.org>; Wed,  2 Oct 2024 20:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727901389; cv=none; b=a8UzjL6RksDIX1m17WKKS3LQvHtWmCrCSGgEBfLd/91BpOZd6+soRFGsCSoe6V3fgijwqBk3z4MreMwCfwKxHpQIqJKRmNALr6pz7EKV8I6hA/kdKvE8qKDHi8x84c/1jQ0KWYzL0kJKQVInBkBm0b7vZP7iLu45adBq3v28+bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727901389; c=relaxed/simple;
	bh=TnvNzIPxRqnoVDWbDVc5U5oEo3D0z0kKOnrLjGfLEtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zfi21C9fpTDMqTFqcNsti8oIenJsXn08YerTuVnPpH+UTGlc7wz++K/zNCe8HFNK/ORTRDNhJRlAWrsArvQJry5Mv8ip3gvHLpSAYTHgzjzrFRUPd93CJU1WnATk4QHI7+QRHUjHjMEj47u9eyPjquUqq1U4TpEc+z93wmH6U1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=2GjycDLv; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="2GjycDLv"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XJmmn5m4NzlgMVN;
	Wed,  2 Oct 2024 20:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1727901372; x=1730493373; bh=QKui+
	dYOyAao4c94XqQRbrEa5zd795y5WnpFO/Yx1J8=; b=2GjycDLvgY8QTq5eurbsJ
	gJ8x5ZlbT7PEeSEsfwnNjVFTK0jlETGTHjQI2IOfWjFbXYsN59osUf5TD3Z+iHmq
	zR7Wwm6zRvCgigW1TuaT2SqkUuUk5IhDas367BWURupnpJje8KZ/AzaOA7K1VGu4
	NThSRkxjRd0je1y+Zw141XywBsu66yMDmc0JwAVKhje2Y3mfvWrlRlFs1Sia15a0
	hyqUZpR/LnhlfdyzH3idiKPXj0KRa6WKhtTFfgmLKxX0Cd3hm2+KXIsv4TiYrmqm
	SXTOhin4KpxS/els8Di4OrXGByxlE6GOJy3UXjU1jOdVEnAzhG+lRVHbZNRf2M2L
	A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id A3SJwxw0NRmP; Wed,  2 Oct 2024 20:36:12 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XJmmX1NwzzlgMVy;
	Wed,  2 Oct 2024 20:36:12 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v2 05/11] scsi: sym53c8xx: Remove the changelog
Date: Wed,  2 Oct 2024 13:33:57 -0700
Message-ID: <20241002203528.4104996-6-bvanassche@acm.org>
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
 Documentation/scsi/ChangeLog.sym53c8xx   | 593 -----------------------
 Documentation/scsi/ChangeLog.sym53c8xx_2 | 144 ------
 2 files changed, 737 deletions(-)
 delete mode 100644 Documentation/scsi/ChangeLog.sym53c8xx
 delete mode 100644 Documentation/scsi/ChangeLog.sym53c8xx_2

diff --git a/Documentation/scsi/ChangeLog.sym53c8xx b/Documentation/scsi/=
ChangeLog.sym53c8xx
deleted file mode 100644
index 3435227a2bed..000000000000
--- a/Documentation/scsi/ChangeLog.sym53c8xx
+++ /dev/null
@@ -1,593 +0,0 @@
-Sat May 12 12:00 2001 Gerard Roudier (groudier@club-internet.fr)
-	* version sym53c8xx-1.7.3c
-	- Ensure LEDC bit in GPCNTL is cleared when reading the NVRAM.
-	  Fix sent by Stig Telfer <stig@api-networks.com>.
-	- Backport from SYM-2 the work-around that allows to support=20
-	  hardwares that fail PCI parity checking.
-	- Check that we received at least 8 bytes of INQUIRY response=20
-	  for byte 7, that contains device capabilities, to be valid.
-	- Define scsi_set_pci_device() as nil for kernel < 2.4.4.
-	- + A couple of minor changes.
-	 =20
-Sat Apr 7 19:30 2001 Gerard Roudier (groudier@club-internet.fr)
-	* version sym53c8xx-1.7.3b
-	- Fix an unaligned LOAD from scripts (was used as dummy read).
-	- In ncr_soft_reset(), only try to ABORT the current operation=20
-	  for chips that support SRUN bit in ISTAT1 and if SCRIPTS are=20
-	  currently running, as 896 and 1010 manuals suggest.
-	- In the CCB abort path, do not assume that the CCB is currently=20
-	  queued to SCRIPTS. This is not always true, notably after a=20
-	  QUEUE FULL status or when using untagged commands.
-
-Sun Mar 4 18:30 2001 Gerard Roudier (groudier@club-internet.fr)
-	* version sym53c8xx-1.7.3a
-	- Fix an issue in the ncr_int_udc() (unexpected disconnect)
-	  handling. If the DSA didn't match a CCB, a bad write to=20
-	  memory could happen.
-
-Mon Feb 12 22:30 2001 Gerard Roudier (groudier@club-internet.fr)
-	* version sym53c8xx-1.7.3
-	- Support for hppa.
-	  Tiny patch sent to me by Robert Hirst.
-	- Tiny patch for ia64 sent to me by Pamela Delaney.
-
-Tue Feb 6 13:30 2001 Gerard Roudier (groudier@club-internet.fr)
-	* version sym53c8xx-1.7.3-pre1
-	- Call pci_enable_device() as AC wants this to be done.
-	- Get both the BAR cookies used by CPU and actual PCI BAR=20
-	  values used from SCRIPTS. Recent PCI chips are able to=20
-	  access themselves using internal cycles, but they compare=20
-	  BAR values to destination address to make decision.
-	  Earlier chips simply use PCI transactions to access IO=20
-	  registers from SCRIPTS.
-	  The bus_dvma_to_mem() interface that reverses the actual=20
-	  PCI BAR value from the BAR cookie is now useless.
-	  This point had been discussed at the list and the solution=20
-	  got approved by PCI code maintainer (Martin Mares).
-	- Merge changes for linux-2.4 that declare the host template=20
-	  in the driver object also when the driver is statically=20
-	  linked with the kernel.
-	- Increase SCSI message size up to 12 bytes, given that 8=20
-	  bytes was not enough for the PPR message (fix).
-	- Add field 'maxoffs_st' (max offset for ST data transfers).
-	  The C1010 supports offset 62 in DT mode but only 31 in=20
-	  ST mode, to 2 different values for the max SCSI offset=20
-	  are needed. Replace the obviously wrong masking of the=20
-	  offset against 0x1f for ST mode by a lowering to=20
-	  maxoffs_st of the SCSI offset in ST mode.
-	- Refine a work-around for the C1010-66. Revision 1 does=20
-	  not requires extra cycles in DT DATA OUT phase.
-	- Add a missing endian-ization (abrt_tbl.addr).
-	- Minor clean-up in the np structure for fields accessed=20
-	  from SCRIPTS that requires special alignments.
-
-Sun Sep 24 21:30 2000 Gerard Roudier (groudier@club-internet.fr)
-	* version sym53c8xx-1.7.2
-	- Remove the hack for PPC added in previous driver version.
-	- Add FE_DAC feature bit to distinguish between 64 bit PCI=20
-	  addressing (FE_DAC) and 64 bit PCI interface (FE_64BIT).
-	- Get rid of the boot command line "ultra:" argument.
-	  This parameter wasn't that clever since we can use "sync:"=20
-	  for Ultra/Ultra2 settings, and for Ultra3 we may want to=20
-	  pass PPR options (for now only DT clocking).
-	- Add FE_VARCLK feature bit that indicates that SCSI clock=20
-	  frequency may vary depending on board design and thus,=20
-	  the driver should try to evaluate the SCSI clock.
-	- Simplify the way the driver determine the SCSI clock:
-	  ULTRA3 -> 160 MHz, ULTRA2 -> 80 MHz otherwise 40 MHz.
-	  Measure the SCSI clock frequency if FE_VARCLK is set.
-	- Remove FE_CLK80 feature bit that got useless.
-	- Add support for the SYM53C875A (Pamela Delaney).
-
-Wed Jul 26 23:30 2000 Gerard Roudier (groudier@club-internet.fr)
-	* version sym53c8xx-1.7.1
-	- Provide OpenFirmware path through the proc FS on PPC.
-	- Download of on-chip SRAM using memcpy_toio() doesn't work=20
-	  on PPC. Restore previous method (MEMORY MOVE from SCRIPTS).
-	- Remove trailing argument #2 from a couple of #undefs.
-
-Sun Jul 09 16:30 2000 Gerard Roudier (groudier@club-internet.fr)
-	* version sym53c8xx-1.7.0
-	- Remove the PROFILE C and SCRIPTS code.
-	  This facility was not this useful and thus was not longer=20
-	  desirable given the increasing complexity of the driver code.
-	- Merges from FreeBSD sym-1.6.2 driver:
-	  * Clarify memory barriers needed by the driver for architectures=20
-	    that implement a weak memory ordering.
-	  * Simpler handling of illegal phases and data overrun from=20
-	    SCRIPTS. These errors are now immediately reported to=20
-	    the C code by an interrupt.
-	  * Sync the residual handling code with sym-1.6.2 and now=20
-	    report `resid' to user for linux version >=3D 2.3.99=20
-	- General cleanup:
-	  Move definitions for barriers and IO/MMIO operations to the=20
-	  sym53c8xx_defs.h header files. They are now shared by the=20
-	  both drivers.
-	  Remove unused options that claimed to optimize for the 896.
-	  If fact, they were not this clever. :)
-	  Use SCSI_NCR_IOMAPPED instead of NCR_IOMAPPED.
-	  Remove a couple of unused fields from data structures.
-
-Thu May 11 12:40 2000 Pam Delaney (pam.delaney@lsil.com)
-	* version sym53c8xx-1.6b
-	- Merged version.
-
-Mon Apr 24 12:00 2000 Gerard Roudier (groudier@club-internet.fr)
-	* version sym53c8xx-1.5m
-	- Return value 1 (instead of 0) from the driver setup routine.
-	- Do not enable PCI DAC cycles. This just broke support for=20
-	  SYM534C896 on sparc64. Problem fixed by David S. Miller.
-
-Fri Apr 14 9:00 2000 Pam Delaney (pam.delaney@lsil.com)
-	* version sym53c8xx-1.6b-9
-	- Added 53C1010_66 support.
-	- Small fix to integrity checking code.
-	- Removed requirement for integrity checking if want to run
-	  at ultra 3.
-=20
-Sat Apr 1  12:00 2000 Gerard Roudier (groudier@club-internet.fr)
-	* version sym53c8xx-1.5l
-	- Tiny change for __sparc__ appeared in 2.3.99-pre4.1 that=20
-	  applies to cache line size (? Probably from David S Miller).
-	- Make sure no data transfer will happen for Scsi_Cmnd requests=20
-	  that supply SCSI_DATA_NONE direction (this avoids some BUG()=20
-	  statement in the PCI code when a data buffer is also supplied).
-
-Sat Mar 11 12:00 2000 Gerard Roudier (groudier@club-internet.fr)
-	* version sym53c8xx-1.6b-5
-	- Test against expected data transfer direction from SCRIPTS.
-	- Add support for the new dynamic dma mapping kernel interface.
-	  Requires Linux-2.3.47 (tested with pre-2.3.47-6).
-	  Many thanks to David S. Miller for his preliminary changes=20
-	  that have been useful guidelines.
-	- Get data transfer direction from the scsi command structure=20
-	  (Scsi_Cmnd) with kernels that provide this information.
-
-Mon Mar  6 23:30 2000 Gerard Roudier (groudier@club-internet.fr)
-	* version sym53c8xx-1.5k
-	- Test against expected data transfer direction from SCRIPTS.
-	- Revert the change in 'ncr_flush_done_cmds()' but unmap the=20
-	  scsi dma buffer prior to queueing the command to our done=20
-	  list.
-	- Miscellaneous (minor) fixes in the code added in driver=20
-	  version 1.5j.
-
-Mon Feb 14 4:00 2000 Pam Delaney (pam.delaney@lsil.com)
- 	* version sym53c8xx-pre-1.6b-2.
-	- Updated the SCRIPTS error handling of the SWIDE
-	  condition - to remove any reads of the sbdl
-	  register. Changes needed because the 896 and 1010
-	  chips will check parity in some special circumstances.
-	  This will cause a parity error interrupt if not in
-	  data phase.  Changes based on those made in the
-	  FreeBSD driver version 1.3.2.
-
-Sun Feb 20 11:00 2000 Gerard Roudier (groudier@club-internet.fr)
-	* version sym53c8xx-1.5j
-	- Add support for the new dynamic dma mapping kernel interface.
-	  Requires Linux-2.3.47 (tested with pre-2.3.47-6).
-	  Many thanks to David S. Miller for his preliminary changes=20
-	  that have been useful guidelines, for having reviewed the=20
-	  code and having tested this driver version on Ultra-Sparc.
-	- 2 tiny bugs fixed in the PCI wrapper that provides support=20
-	  for early kernels without pci device structure.
-	- Get data transfer direction from the scsi command structure=20
-	  (Scsi_Cmnd) with kernels that provide this information.
-	- Fix an old bug that only affected 896 rev. 1 when driver=20
-	  profile support option was set in kernel configuration.
-
-Fri Jan 14 14:00 2000 Pam Delaney (pam.delaney@lsil.com)
- 	* version sym53c8xx-pre-1.6b-1.
-	- Merge parallel driver series 1.61 and 1.5e=20
-
-Tue Jan 11 14:00 2000 Pam Delaney (pam.delaney@lsil.com)
-	* version sym53c8xx-1.61
-	- Added support for mounting disks on wide-narrow-wide
-	  scsi configurations.=20
-	- Modified offset to be a maximum of 31 in ST mode,=20
-	  62 in DT mode.
-	- Based off of 1.60
-
-Mon Jan 10 10:00 2000 Pam Delaney (pam.delaney@lsil.com)
-	* version sym53c8xx-1.60
-	- Added capability to use the integrity checking code
-	  in the kernel (optional).
-	-  Added PPR negotiation.
-	- Added support for 53C1010 Ultra 3 part.
-	- Based off of 1.5f
-
-Sat Jan 8  22:00 2000 Gerard Roudier (groudier@club-internet.fr)
-	* version sym53c8xx-1.5h
-	- Add year 2000 copyright.
-	- Display correctly bus signals when bus is detected wrong.
-	- Some fix for Sparc from DSM that went directly to kernel tree.
-
-Mon Dec 6  22:00 1999 Gerard Roudier (groudier@club-internet.fr)
-	* version sym53c8xx-1.5g
-	- Change messages written by the driver at initialisation and=20
-	  through the /proc FS (rather cosmetic changes that consist in
-	  printing out the PCI bus number and PCI device/function).
-	- Ensure the SCRIPTS processor is stopped while calibrating the=20
-	  SCSI clock (the initialisation code has been a bit reworked).
-	  Change moved to the FreeBSD sym_hipd driver).
-	- Some fixes in the MODIFY_DP/IGN_RESIDUE code and residual=20
-	  calculation (moved from FreeBSD sym_hipd driver).
-	- Add NVRAM support for Tekram boards that use 24C16 EEPROM.
-	  Code moved from the FreeBSD sym_hipd driver, since it has=20
-	  been that one that got this feature first.
-	- Definitely disable overlapped PCI arbitration for all dual=20
-	  function chips, since I cannot make sure for what chip revisions=20
-	  it is actually safe.
-	- Add support for the SYM53C1510D (also for ncr53c8xx).
-	- Fix up properly the PCI latency timer when needed or asked for.
-	- Get rid of the old PCI bios interface, but preserve kernel 2.0=20
-	  compatibility from a simple wrapper.
-	- Update the poor Tekram sync factor table.
-	- Fix in a tiny 'printk' bug that may oops in case of extended=20
-	  errors (unrecovered parity error, data overrun, etc ...)
-	  (Sent by Pamela Delaney from LSILOGIC)
-	- Remove the compilation condition about having to acquire the=20
-	  io_request_lock since it seems to be a definite feature now.:)
-	- Change get_pages by GetPages since Linux >=3D 2.3.27 now wants=20
-	  get_pages to ever be used as a kernel symbol (from 2.3.27).
-	- proc_dir structure no longer needed for kernel >=3D 2.3.27.
-
-Sun Oct  3  19:00 1999 Gerard Roudier (groudier@club-internet.fr)
-	* version sym53c8xx-1.5f
-	- Change the way the driver checks the PCI clock frequency, so=20
-	  that overclocked PCI BUS up to 48 MHz will not be refused.
-	  The more the BUS is overclocked, the less the driver will=20
-	  guarantee that its measure of the SCSI clock is correct.
-	- Backport some minor improvements of SCRIPTS from the sym_hipd=20
-	  driver.
-	- Backport the code rewrite of the START QUEUE dequeuing (on=20
-	  bad scsi status received) from the sym_hipd driver.
-
-Sat Sep 11  11:00 1999 Gerard Roudier (groudier@club-internet.fr)
-	* version sym53c8xx-1.5e
-	- New linux-2.3.13 __setup scheme support added.
-	- Cleanup of the extended error status handling:
-	  Use 1 bit per error type.
-	- Also save the extended error status prior to auto-sense.
-	- Add the FE_DIFF chip feature bit to indicate support of=20
-	  diff probing from GPIO3 (825/825A/876/875).
-	- Remove the quirk handling that has been useless since day one.
-	- Work-around PCI chips being reported twice on some platforms.
-	- Add some redundant PCI reads in order to deal with common=20
-	  bridge misbehaviour regarding posted write flushing.
-	- Add some other conditional code for people who have to deal
-	  with really broken bridges (they will have to edit a source=20
-	  file to try these options).
-	- Handle correctly (hopefully) jiffies wrap-around.
-	- Restore the entry used to detect 875 until revision 0xff.
-	  (I removed it inadvertently, it seems :) )
-	- Replace __initfunc() which is deprecated stuff by __init which=20
-	  is not yet so. ;-)
-	- Rewrite the MESSAGE IN scripts more generic by using a MOVE=20
-	  table indirect. Extended messages of any size are accepted now.
-	  (Size is limited to 8 for now, but a constant is just to be=20
-	  increased if necessary)
-	- Fix some bug in the fully untested MDP handling:) and share=20
-	  some code between MDP handling and residual calculation.
-	- Calculate the data transfer residual as the 2's complement=20
-	  integer (A positive value in returned on data overrun, and=20
-	  a negative one on underrun).
-	- Add support of some 'resource handling' for linux-2.3.13.
-	  Basically the BARs have been changed to something more complex=20
-	  in the pci_dev structure.
-	- Remove some deprecated code.
-
-Sat Jun  5  11:00 1999 Gerard Roudier (groudier@club-internet.fr)
-	* version sym53c8xx-1.5c
-	- Do not negotiate on auto-sense if we are currently using 8 bit=20
-	  async transfer for the target.
-	- Only check for SISL/RAID on i386 platforms.
-	  (A problem has been reported on PPC with that code).
-	- On MSG REJECT for a negotiation, the driver attempted to restart=20
-	  the SCRIPT processor when this one was already running.
-
-Sat May 29  12:00 1999 Gerard Roudier (groudier@club-internet.fr)
-	* version sym53c8xx-1.5b
-	- Force negotiation prior auto-sense.
-	  This ensures that the driver will be able to grab the sense data=20
-	  from a device that has received a BUS DEVICE RESET message from=20
-	  another initiator.
-	- Complete all disconnected CCBs for a logical UNIT if we are told=20
-	  about a UNIT ATTENTION for a RESET condition by this target.
-	- Add the control command 'cleardev' that allows to send a ABORT =20
-	  message to a logical UNIT (for test purpose).
-
-Tue May 25  23:00 1999 Gerard Roudier (groudier@club-internet.fr)
-	* version sym53c8xx-1.5a
-	- Add support for task abort and bus device reset SCSI message=20
-	  and implement proper synchronisation with SCRIPTS to handle
-          correctly task abortion without races.
-	- Send an ABORT message (if untagged) or ABORT TAG message (if tagged)
-	  when the driver is told to abort a command that is disconnected and=20
-	  complete the command with appropriate error.
-	  If the aborted command is not yet started, remove it from the start=20
-	  queue and complete it with error.
-	- Add the control command 'resetdev' that allows to send a BUS=20
-	  DEVICE RESET message to a target (for test purpose).
-	- Clean-up some unused or useless code.
-
-Fri May 21  23:00 1999 Gerard Roudier (groudier@club-internet.fr)
-	* version sym53c8xx-1.5
-	- Add support for CHMOV with Wide controllers.
-	- Handling of the SWIDE (low byte residue at the end of a CHMOV=20
-	  in DATA IN phase with WIDE transfer when the byte count gets odd).
-	- Handling of the IGNORE WIDE RESIDUE message.
-	  Handled from SCRIPTS as possible with some optimizations when both=20
-	  a wide device and the controller are odd at the same time (SWIDE=20
-	  present and IGNORE WIDE RESIDUE message on the BUS at the same time).
-	- Check against data OVERRUN/UNDERRUN condition at the end of a data=20
-	  transfer, whatever a SWIDE is present (OVERRUN in DATA IN phase)=20
-	  or the SODL is full (UNDERRUN in DATA out phase).
-	- Handling of the MODIFY DATA POINTER message.
-	  This one cannot be handled from SCRIPTS, but hopefully it will not
-	  happen very often. :)
-	- Large rewrite of the SCSI MESSAGE handling.
-
-Sun May 9  11:00 1999 Gerard Roudier (groudier@club-internet.fr)
-	* version sym53c8xx-1.4
-	- Support for IMMEDIATE ARBITRATION.
-	  See the README file for detailed information about this feature.
-	  Requires both a compile option and a boot option.
-	- Minor SCRIPTS optimization in reselection pattern for LUN 0.
-	- Simpler algorithm to deal with SCSI command starvation.
-	  Just use 2 tag counters in flip/flop and switch to the other=20
-	  one every 3 seconds.
-	- Do some work in SCRIPTS after the SELECT instruction and prior=20
-	  to testing for a PHASE. SYMBIOS say this feature is working fine.=20
-	  (Btw, only problems with Toshiba 3401B had been reported).
-	- Measure the PCI clock speed and do not attach controllers if=20
-	  result is greater than 37 MHz. Since the precision of the=20
-	  algorithm (from Stefan Esser) is better than 2%, this should=20
-	  be fine.
-	- Fix the misdetection of SYM53C875E (was detected as a 876).
-	- Fix the misdetection of SYM53C810 not A (was detected as a 810A).
-	- Support for up to 256 TAGS per LUN (CMD_PER_LUN).
-	  Currently limited to 255 due to Linux limitation. :)
-	- Support for up to 508 active commands (CAN_QUEUE).
-	- Support for the 53C895A by Pamela Delaney <pam.delaney@lsil.com>
-	  The 53C895A contains all of the features of the 896 but has only=20
-	  one channel and has a 32 bit PCI bus. It does 64 bit PCI addressing=20
-	  using dual cycle PCI data transfers.
-	- Miscellaneous minor fixes.
-	- Some additions to the README.ncr53c8xx file.
-
-Tue Apr 15  10:00 1999 Gerard Roudier (groudier@club-internet.fr)
-	* version sym53c8xx-1.3e
-	- Support for any number of LUNs (64) (SPI2-compliant).
-	  (Btw, this may only be ever useful under linux-2.2 ;-))
-
-Sun Apr 11  10:00 1999 Gerard Roudier (groudier@club-internet.fr)
-	* version sym53c8xx-1.3d
-	- Add 'hostid:#id' boot option. This option allows to change the=20
-	  default SCSI id the driver uses for controllers.
-	- Make SCRIPTS not use self-mastering for PCI.
-	  There were still 2 places the driver used this feature of the=20
-	  53C8XX family.
-	- Move some data structures (nvram layouts and driver set-up) to=20
-	  the sym53c8xx_defs.h file. So, the both drivers will share them.
-	- Set MAX LUNS to 16 (instead of 8).
-
-Sat Mar 20  21:00 1999 Gerard Roudier (groudier@club-internet.fr)
-	* version sym53c8xx-1.3b
-	- Add support for NCR PQS PDS.
-	  James Bottomley <James.Bottomley@columbiasc.ncr.com>
-	- Allow value 0 for host ID.
-	- Support more than 8 controllers (> 40 in fact :-) )
-	- Add 'excl=3D#ioaddr' boot option: exclude controller.
-	  (Version 1.3a driver)
-
-Thu Mar 11  23:00 1999 Gerard Roudier (groudier@club-internet.fr)
-	* version sym53c8xx-1.3   (8xx-896 driver bundle)
-	- Equivalent changes as ncr53c8xx-3.2 due to the driver bundle.
-	  (See Changelog.ncr53c8xx)
-	- Do a normal soft reset as first chip reset, since aborting current=20
-	  operation may raise an interrupt we are not able to handle since=20
-	  the interrupt handler is not yet established.
-
-Sat Mar 6  11:00 1999 Gerard Roudier (groudier@club-internet.fr)
-	* version sym53c8xx-1.2b
-	- Fix some oooold bug that hangs the bus if a device rejects a=20
-	  negotiation. Btw, the corresponding stuff also needed some cleanup=20
-	  and thus the change is a bit larger than it could have been.
-	- Still some typo that made compilation fail for 64 bit (trivial fix).
-
-Sun Feb 21  20:00 1999 Gerard Roudier (groudier@club-internet.fr)
-	* version sym53c8xx-1.2a
-	- The rewrite of the interrupt handling broke the SBMC interrupt=20
-	  handling due to a 1 bit mask tiny error. Hopefully fixed.
-	- If INQUIRY came from a scatter list, the driver looked into=20
-	  the scatterlist instead of the data.:) Since this should never
-	  happen, we just discard the data if use_sg is not zero.
-
-Fri Feb 12  23:00 1999 Gerard Roudier (groudier@club-internet.fr)
-	* version sym53c8xx-1.2
-	- Major rewrite of the interrupt handling and recovery stuff for=20
-	  the support of non compliant SCSI removal, insertion and all=20
-	  kinds of screw-up that may happen on the SCSI BUS.
-	  Hopefully, the driver is now unbreakable or may-be, it is just=20
-	  quite broken. :-)
-	  Many thanks to Johnson Russel (Symbios) for having responded to=20
-	  my questions and for his interesting advices and comments about=20
-	  support of SCSI hot-plug.
-	- Add 'recovery' option to driver set-up.
-	- Negotiate SYNC data transfers with CCS devices.
-	- Deal correctly with 64 bit PCI address registers on Linux 2.2.
-	  Pointed out by Leonard Zubkoff.
-
-Sun Jan 31  18:00 1999 Gerard Roudier (groudier@club-internet.fr)
-	* version sym53c8xx-1.1a
-	- Some 896 chip revisions (all for now :-)), may hang-up if the=20
-	  soft reset bit is set at the wrong time while SCRIPTS are running.
-	  We need to first abort the current SCRIPTS operation prior to=20
-	  resetting the chip. This fix has been sent to me by SYMBIOS/LSI=20
-	  and I just translated it into ncr53c8xx syntax.
-	  Must be considered 100 % trustable, unless I did some mistake=20
-	  when translating it. :-)
-
-Sun Jan 24  18:00 1999 Gerard Roudier (groudier@club-internet.fr)
-	* version sym53c8xx-1.1
-	- Major rewrite of the SCSI parity error handling.
-	  The information contained in the data manuals is incomplete about
-	  this feature.
-	  I asked SYMBIOS about and got in reply the explanations that are=20
-	  _indeed_ missing in the data manuals.
-	- Allow to tune request_irq() flags from the boot command line using=20
-	  ncr53c8xx=3Dirqm:??, as follows:
-	  a) If bit 0x10 is set in irqm, SA_SHIRQ flag is not used.
-	  b) If bit 0x20 is set in irqm, SA_INTERRUPT flag is not used.
-	  By default the driver uses both SA_SHIRQ and SA_INTERRUPT.
-	  Option 'ncr53c8xx=3Dirqm:0x20' may be used when an IRQ is shared by=20
-	  a 53C8XX adapter and a network board.
-	- Fix for 64 bit PCI address register calculation. (Lance Robinson)
-	- Fix for big-endian in phase mismatch handling. (Michal Jaegermann)
-
-Fri Jan  1  20:00 1999 Gerard Roudier (groudier@club-internet.fr)
-	* version sym53c8xx-1.0a
-	- Waiting list look-up didn't work for the first command of the list.
-	  Hopefully fixed, but tested on paper only. ;)
-	- Remove the most part of PPC specific code for Linux-2.2.
-	  Thanks to Cort.
-	- Some other minors changes.
-
-Sat Dec 19  21:00 1998 Gerard Roudier (groudier@club-internet.fr)
-	* version sym53c8xx-1.0
-	- Define some new IO registers for the 896 (istat1, mbox0, mbox1)
-	- Revamp slightly the Symbios NVRAM lay-out based on the excerpt of=20
-	  the header file I received from Symbios.
-	- Check the PCI bus number for the boot order (Using a fast=20
-	  PCI controller behind a PCI-PCI bridge seems sub-optimal).
-	- Disable overlapped PCI arbitration for the 896 revision 1.
-	- Reduce a bit the number of IO register reads for phase mismatch=20
-	  by reading DWORDS at a time instead of BYTES.
-
-Thu Dec  3  24:00 1998 Gerard Roudier (groudier@club-internet.fr)
-	* version pre-sym53c8xx-0.18
-	- I received this afternoon a 896 from SYMBIOS and started testing =20
-	  the driver with this beast. After having fixed 3 buglets, it worked =20
-	  with all features enabled including the phase mismatch handling=20
-	  from SCRIPTS. Since this feature is not yet tested enough, the=20
-	  boot option 'ncr53c8xx=3Dspecf:1' is still required to enable the=20
-	  driver to handle PM from SCRIPTS.=20
-
-Sun Nov 29  18:00 1998 Gerard Roudier (groudier@club-internet.fr)
-	* version pre-sym53c8xx-0.17
-	- The SISL RAID change requires now remap_pci_mem() stuff to be=20
-	  compiled for __i386__ when normal IOs are used.
-	- The PCI memory read from SCRIPTS that should ensure ordering=20
-	  was in fact misplaced. BTW, this may explain why broken PCI=20
-	  device drivers regarding ordering are working so well. ;-)
-	- Rewrite ncr53c8xx_setup (boot command line options) since the =20
-	  binary code was a bit too bloated in my opinion.
-	- Make the code simpler in the wakeup_done routine.
-
-Tue Nov 24  23:00 1998 Gerard Roudier (groudier@club-internet.fr)
-	* version pre-sym53c8xx-0.16
-	- Add SCSI_NCR_OPTIMIZE_896_1 compile option and 'optim' boot option.
-	  When set, the driver unconditionally assumes that the interrupt
-	  handler is called for command completion, then clears INTF, scans=20
-	  the done queue and returns if some completed CCB is found. If no=20
-	  completed CCB are found, interrupt handling will proceed normally.
-	  With a 896 that handles MA from SCRIPTS, this can be a great win,=20
-	  since the driver will never performs PCI read transactions, but=20
-	  only PCI write transactions that may be posted.
-	  If the driver haven't to also raise the SIGP this would be perfect.
-	  Even with this penalty, I think that this will work great.
-	  Obviously this optimization makes sense only if the IRQ is not=20
-	  shared with another device.
-	- Still a buglet in the tags initial settings that needed to be fixed.
-	  It was not possible to disable TGQ at system startup for devices=20
-	  that claim TGQ support. The driver used at least 2 for the queue=20
-	  depth but didn't keep track of user settings for tags depth lower
-	  than 2.
-
-Thu Nov 19  23:00 1998 Gerard Roudier (groudier@club-internet.fr)
-	* version pre-sym53c8xx-0.15
-	- Add support for hardware LED control of the 896.
-	- Ignore chips that are driven by SISL RAID (DAC 960).
-	  Change sent by Leonard Zubkoff and slightly reworked.
-	- Prevent 810A rev 11 and 860 rev 1 from using cache line based=20
-	  transactions since those early chip revisions may use such on=20
-	  LOAD/STORE instructions (work-around).
-	- Remove some useless and bloat code from the pci init stuff.
-	- Do not use the readX()/writeX() kernel functions for __i386__,=20
-	  since they perform useless masking operations in order to deal=20
-	  with broken driver in 2.1.X kernel.
-
-Wed Nov 11  10:00 1998 Gerard Roudier (groudier@club-internet.fr)
-	* version pre-sym53c8xx-0.14
-	- The driver was unhappy when configured with default_tags > MAX_TAGS
-	  Hopefully doubly-fixed.
-	- Set PCI_PARITY in PCI_COMMAND register in not set (PCI fix-up).
-	- Print out some message if phase mismatch is handled from SCRIPTS.
-
-Sun Nov 1  14H00 1998 Gerard Roudier (groudier@club-internet.fr)
-	* version pre-sym53c8xx-0.13
-	- Some rewrite of the device detection code. This code had been=20
-	  patched too much and needed to be face-lifted a bit.
-	  Remove all platform dependent fix-ups that was not needed or
-	  conflicted with some other driver code as work-arounds.
-	  Reread the NVRAM before the calling of ncr_attach(). This spares=20
-	  stack space and so allows to handle more boards.
-	  Handle 64 bit base addresses under linux-2.0.X.
-	  Set MASTER bit in PCI COMMAND register if not set.
-
-Wed Oct 30 22H00 1998 Gerard Roudier (groudier@club-internet.fr)
-	* version pre-sym53c8xx-0.12
-	- Damned! I just broke the driver for Alpha by leaving a stale=20
-	  instruction in the source code. Hopefully fixed.
-	- Do not set PFEN when it is useless. Doing so we are sure that BOF=20
-	  will be active, since the manual appears to be very unclear on what=20
-	  feature is actually used by the chip when both PFEN and BOF are=20
-	  set.
-
-Sat Oct 24 16H00 1998 Gerard Roudier (groudier@club-internet.fr)
-	* version pre-sym53c8xx-0.11
-	- LOAD/STORE instructions were miscompiled for register offsets=20
-	  beyond 0x7f. This broke accesses to 896' new registers.
-	- Disable by default Phase Mismatch handling from SCRIPTS, since=20
-	  current 896 rev.1 seems not to operate safely with the driver
-	  when this feature is enabled (and above LOAD/STORE fix applied).
-	  I will change the default to 'enabled' when this problem will be=20
-	  solved.
-	  Using boot option 'ncr53c8xx=3Dspecf:1' enables this feature.
-	- Implement a work-around (DEL 472 - ITEM 5) that should allow the=20
-	  driver to safely enable hardware phase mismatch with 896 rev. 1.
-
-Tue Oct 20 22H00 1998 Gerard Roudier (groudier@club-internet.fr)
-	* version pre-sym53c8xx-0.10
-	- Add the 53c876 description to the chip table. This is only useful=20
-	  for printing the right name of the controller.
-	- Add additional checking of INQUIRY data:
-	  Check INQUIRY data received length is at least 7. Byte 7 of=20
-	  inquiry data contains device features bits and the driver might=20
-	  be confused by garbage. Also check peripheral qualifier.
-	- Use a 1,3,5,...MAXTAGS*2+1 tag numbering. Previous driver could =20
-	  use any tag number from 1 to 253 and some non conformant devices =20
-	  might have problems with large tag numbers.
-	- Use NAME53C and NAME53C8XX for chip name prefix chip family name.
-	  Just give a try using "sym53c" and "sym53c8xx" instead of "ncr53c"=20
-	  and "ncr53c8xx". :-)
-
-Sun Oct 11 17H00 1998 Gerard Roudier (groudier@club-internet.fr)
-	* version pre-sym53c8xx-0.9
-	- DEL-441 Item 2 work-around for the 53c876 rev <=3D 5 (0x15).
-	- Break ncr_scatter() into 2 functions in order to guarantee best=20
-	  possible code optimization for the case we get a scatter list.
-	- Add the code intended to support up to 1 tera-byte for 64 bit systems=
.
-	  It is probably too early, but I wanted to complete the thing.
-
-Sat Oct 3 14H00 1998 Gerard Roudier (groudier@club-internet.fr)
-	* version pre-sym53c8xx-0.8
-	- Do some testing with io_mapped and fix what needed to be so.
-	- Wait for SCSI selection to complete or time-out immediately after=20
-	  the chip won arbitration, since executing SCRIPTS while the SCSI=20
-	  core is performing SCSI selection breaks the selection procedure=20
-	  at least for some chip revisions.
-	- Interrupt the SCRIPTS if a device does not go to MSG OUT phase after=20
-	  having been selected with ATN. Such a situation is not recoverable,=20
-	  better to fail when we are stuck.
diff --git a/Documentation/scsi/ChangeLog.sym53c8xx_2 b/Documentation/scs=
i/ChangeLog.sym53c8xx_2
deleted file mode 100644
index 9180eb343991..000000000000
--- a/Documentation/scsi/ChangeLog.sym53c8xx_2
+++ /dev/null
@@ -1,144 +0,0 @@
-Sat Dec 30 21:30 2000 Gerard Roudier=20
-	* version sym-2.1.0-20001230
-	- Initial release of SYM-2.
-
-Mon Jan 08 21:30 2001 Gerard Roudier=20
-	* version sym-2.1.1-20010108
-	- Change a couple of defines containing ncr or NCR by their=20
-	  equivalent containing sym or SYM instead.
-
-Sun Jan 14 22:30 2001 Gerard Roudier=20
-	* version sym-2.1.2-20010114
-	- Fix a couple of printfs:
-	  * Add the target number to the display of transfer parameters.
-	  * Make the display of TCQ and queue depth clearer.
-
-Wed Jan 17 23:30 2001 Gerard Roudier=20
-	* version sym-2.1.3-20010117
-	- Wrong residual values were returned in some situations.
-	  This broke cdrecord with linux-2.4.0, for example.
-
-Sat Jan 20 18:00 2001 Gerard Roudier=20
-	* version sym-2.1.4-20010120
-	- Add year 2001 to Copyright.
-	- A tiny bug in the dma memory freeing path has been fixed.
-	  (Driver unload failed with a bad address reference).
-
-Wed Jan 24 21:00 2001 Gerard Roudier=20
-	* version sym-2.1.5-20010124
-	- Make the driver work under Linux-2.4.x when statically linked=20
-	  with the kernel.
-	- Check against memory allocation failure for SCRIPTZ and add the=20
-	  missing free of this memory on instance detach.
-	- Check against GPIO3 pulled low for HVD controllers (driver did=20
-	  just the opposite).
-	  Misdetection of BUS mode was triggered on module reload only,=20
-	  since BIOS settings were trusted instead on first load.
-
-Wed Feb 7 21:00 2001 Gerard Roudier=20
-	* version sym-2.1.6-20010207
-	- Call pci_enable_device() as wished by kernel maintainers.
-	- Change the sym_queue_scsiio() interface.
-	  This is intended to simplify portability.
-	- Move the code intended to deal with the downloading of SCRIPTS
-	  from SCRIPTS :) in the patch method (was wrongly placed in=20
-	  the SCRIPTS setup method).
-	- Add a missing cpu_to_scr()  (np->abort_tbl.addr)
-	- Remove a wrong cpu_to_scr() (np->targtbl_ba)
-	- Cleanup a bit the PPR failure recovery code.
-
-Sat Mar 3 21:00 2001 Gerard Roudier=20
-	- Add option SYM_OPT_ANNOUNCE_TRANSFER_RATE and move the=20
-	  corresponding code to file sym_misc.c.
-	  Also move the code that sniffes INQUIRY to sym_misc.c.
-	  This allows to share the corresponding code with NetBSD=20
-	  without polluating the core driver source (sym_hipd.c).
-	- Add optional code that handles IO timeouts from the driver.
-	  (not used under Linux, but required for NetBSD)
-	- Do not assume any longer that PAGE_SHIFT and PAGE_SIZE are
-	  defined at compile time, as at least NetBSD uses variables=20
-	  in memory for that.
-	- Refine a work-around for the C1010-33 that consists in=20
-	  disabling internal LOAD/STORE. Was applied up to revision 1.
-	  Is now only applied to revision 0.
-	- Some code reorganisations due to code moves between files.
-
-Tues Apr 10 21:00 2001 Gerard Roudier=20
-	* version sym-2.1.9-20010412
-	- Reset 53C896 and 53C1010 chip according to the manual.
-	  (i.e.: set the ABRT bit in ISTAT if SCRIPTS are running)
-	- Set #LUN in request sense only if scsi version <=3D 2 and
-	  #LUN <=3D 7.
-	- Set busy_itl in LCB to 1 if the LCB is allocated and a=20
-	  SCSI command is active. This is a simplification.
-	- In sym_hcb_free(), do not scan the free_ccbq if no CCBs=20
-	  has been allocated. This fixes a panic if attach failed.
-	- Add DT/ST (double/simple transition) in the transfer=20
-	  negotiation announce.
-	- Forces the max number of tasks per LUN to at least 64.
-	- Use pci_set_dma_mask() for linux-2.4.3 and above.
-	- A couple of comments fixes.
-
-Wed May 22:00 2001 Gerard Roudier=20
-	* version sym-2.1.10-20010509
-	- Mask GPCNTL against 0x1c (was 0xfc) for the reading of the NVRAM.
-	  This ensure LEDC bit will not be set on 896 and later chips.
-	  Fix sent by Chip Salzenberg <chip@perlsupport.com>.
-	- Define the number of PQS BUSes supported.
-	  Fix sent by Stig Telfer <stig@api-networks.com>
-	- Miscellaneous common code rearrangements due to NetBSD accel=20
-	  ioctl support, without impact on Linux (hopefully).
-
-Mon July 2 12:00 2001 Gerard Roudier=20
-	* version sym-2.1.11-20010702
-	- Add Tekram 390 U2B/U2W SCSI LED handling.
-	  Submitted by Chip Salzenberg <chip@valinux.com>
-	- Add call to scsi_set_pci_device() for kernels >=3D 2.4.4.
-	- Check pci dma mapping failures and complete the IO with some=20
-	  error when such mapping fails.
-	- Fill in instance->max_cmd_len for kernels > 2.4.0.
-	- A couple of tiny fixes ...
-
-Sun Sep 9 18:00 2001 Gerard Roudier=20
-	* version sym-2.1.12-20010909
-	- Change my email address.
-	- Add infrastructure for the forthcoming 64 bit DMA addressing support.
-	  (Based on PCI 64 bit patch from David S. Miller)
-	- Do not use anymore vm_offset_t type.
-
-Sat Sep 15 20:00 2001 Gerard Roudier=20
-	* version sym-2.1.13-20010916
-	- Add support for 64 bit DMA addressing using segment registers.
-	  16 registers for up to 4 GB x 16 -> 64 GB.
-
-Sat Sep 22 12:00 2001 Gerard Roudier=20
-	* version sym-2.1.14-20010922
-	- Complete rewrite of the eh handling. The driver is now using a=20
-	  semaphore in order to behave synchronously as required by the eh=20
-	  threads. A timer is also used to prevent from waiting indefinitely.
-
-Sun Sep 30 17:00 2001 Gerard Roudier=20
-	* version sym-2.1.15-20010930
-	- Include <linux/module.h> unconditionally as expected by latest
-	  kernels.
-	- Use del_timer_sync() for recent kernels to kill the driver timer=20
-	  on module release.
-
-Sun Oct 28 15:00 2001 Gerard Roudier=20
-	* version sym-2.1.16-20011028
-	- Slightly simplify driver configuration.
-	- Prepare a new patch against linux-2.4.13.
-
-Sat Nov 17 10:00 2001 Gerard Roudier=20
-	* version sym-2.1.17
-	- Fix a couple of gcc/gcc3 warnings.
-	- Allocate separately from the HCB the array for CCBs hashed by DSA.
-	  All driver memory allocations are now not greater than 1 PAGE=20
-	  even on PPC64 / 4KB PAGE surprising setup.
-
-Sat Dec 01 18:00 2001 Gerard Roudier=20
-	* version sym-2.1.17a
-	- Use u_long instead of U32 for the IO base cookie. This is more=20
-	  consistent with what archs are expecting.
-	- Use MMIO per default for Power PC instead of some fake normal IO,
-	  as Paul Mackerras stated that MMIO works fine now on this arch.
