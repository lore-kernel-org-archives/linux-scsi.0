From: Anton Blanchard <anton@samba.org>
Subject: 2.5.51 + fastT FC disk
Date: Fri, 13 Dec 2002 00:24:39 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021212132439.GE6278@krispykreme>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi,

We tested 2.5.51 on a ppc64 box, qlogic 2312 and a fastt700 array. I
had CONFIG_SCSI_REPORT_LUNS and unfortunately it thought the management
LUN was a disk:

  Vendor: IBM       Model: Universal Xport   Rev: 0520
  Type:   Direct-Access                      ANSI SCSI revision: 03

...

SCSI device sdaj: drive cache: write through
SCSI device sdaj: 40960 512-byte hdwr sectors (21 MB)
 sdaj: unknown partition table
Attached scsi disk sdaj at scsi2, channel 0, id 0, lun 31

...

end_request: I/O error, dev sdaj, sector 0

Anton
