From: Meelis Roos <mroos@linux.ee>
Subject: qla4xxx compile failure on 32-bit PowerPC: missing readq and
 writeq
Date: Fri, 20 Aug 2010 00:03:47 +0300 (EEST)
Message-ID: <alpine.SOC.1.00.1008192359310.19654@math.ut.ee>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Kernel list <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


This is current 2.6.36-rc1+git on 32-bit PowerPC:

  CC [M]  drivers/scsi/qla4xxx/ql4_nx.o
drivers/scsi/qla4xxx/ql4_nx.c: In function 'qla4_8xxx_pci_mem_read_direct':
drivers/scsi/qla4xxx/ql4_nx.c:717: error: implicit declaration of function 'readq'
drivers/scsi/qla4xxx/ql4_nx.c: In function 'qla4_8xxx_pci_mem_write_direct':
drivers/scsi/qla4xxx/ql4_nx.c:788: error: implicit declaration of function 'writeq'

readq and writeq are defined in io.h but only when compiling for 64-bit 
kernel. Adding manual #include <linux/io.h> does not help here.

-- 
Meelis Roos (mroos@linux.ee)
