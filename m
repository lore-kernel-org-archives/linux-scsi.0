From: William Lee Irwin III <wli@holomorphy.com>
Subject: 2.5.56-mm1 fails to detect cd burner
Date: Mon, 10 Mar 2003 22:36:27 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030311063627.GJ1399@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

 scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA
 DRIVER, Rev 6.2.26
         <Adaptec 3960D Ultra160 SCSI adapter>
         aic7899: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
 
 (scsi0:A:0:0): Completed command without status.
 (scsi0:A:0:0): Protocol violation in Message-in phase.  Attempting to abort.
 (scsi0:A:0:0): Abort Message Sent
 (scsi0:A:0:0): SCB 3 - Abort Completed.
 scsi0:A:0:0: DV failed to configure device. Please file a bug report against this driver.

It's had other problems burning CD's in 2.5.x



-- wli
