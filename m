From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [0/8]  qla2xxx: Summary of changes...
Date: Mon, 6 Sep 2004 21:26:03 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040907042603.GA29557@praka.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02-qfe0.socal.rr.com ([66.75.162.134]:51882 "EHLO
	ms-smtp-02-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S267556AbUIGE1w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Sep 2004 00:27:52 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

James,

Please apply the following patches I'm about to send to update the
qla2xxx driver.  A summary of the patches can be found towards the end
of this message.

With the exception of the rather large firmware image update (direct
pointer to bzip'd patch listed), subsequent messages will contain
inlined patches.

All patches can be found at the following URL:

        ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.00.00b21k/

Regards,
Andrew Vasquez
QLogic Corporation


ChangeSet@1.1871, 2004-09-04 23:19:51-07:00, andrew.vasquez@qlogic.com
  PCI posting fixes.

ChangeSet@1.1872, 2004-09-06 07:34:57-07:00, andrew.vasquez@qlogic.com
  Dynamically resize request-queue during initialization based
  on the amount of memory available to the ISP.

ChangeSet@1.1873, 2004-09-06 11:34:15-07:00, andrew.vasquez@qlogic.com
  Rework driver DMA allocations to use the DMA pool APIs
  to minimize potential run-time allocation failures.

ChangeSet@1.1874, 2004-09-06 11:47:07-07:00, andrew.vasquez@qlogic.com
  Misc. small fixes:
  
          o Always set an TCQ modifier for each command submitted.
          o Always (re)-initialize NVRAM during execution.
          o Add pci_disable_device() calls to proper locations during
            pci-probe failure and pci-remove.
          o Do not begin processing until the DPC has been marked
            'active'.
          o Fix off-by-one error while copying sense-data.
          o Fix bus-reset issue during back-door execution.

ChangeSet@1.1875, 2004-09-06 11:51:36-07:00, andrew.vasquez@qlogic.com
  Rework interrupt-handler registration in anticipation of future
  chip types.

ChangeSet@1.1876, 2004-09-06 11:57:40-07:00, andrew.vasquez@qlogic.com
  Misc. small enhancements:
  
          o Add 're-scan' and 'initiate lip' support via /proc
            similar to the 7.x series drivers.
          o Add module parameter ql2xprocessnotready, to selectively
            enable/disable the driver's internal NOT_READY check-
            condition handling.

ChangeSet@1.1877, 2004-09-06 12:02:32-07:00, andrew.vasquez@qlogic.com
  Resync with latest released firmware -- 3.03.02

ChangeSet@1.1878, 2004-09-06 12:04:22-07:00, andrew.vasquez@qlogic.com
  Update version number to 8.00.00b21-k.
