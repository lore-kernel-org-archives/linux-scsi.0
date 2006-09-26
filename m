From: Judith Lebzelter <judith@osdl.org>
Subject: Compile warnings for linux-2.6.18-scsi-misc1 on various architectures
Date: Tue, 26 Sep 2006 14:53:57 -0700
Message-ID: <20060926215357.GC26041@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:29073 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S964861AbWIZVx7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Sep 2006 17:53:59 -0400
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id k8QLrvnW020853
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 26 Sep 2006 14:53:58 -0700
Received: from shell0.pdx.osdl.net (localhost [127.0.0.1])
	by shell0.pdx.osdl.net (8.13.1/8.11.6) with ESMTP id k8QLrvSf003238
	for <linux-scsi@vger.kernel.org>; Tue, 26 Sep 2006 14:53:57 -0700
Received: (from judith@localhost)
	by shell0.pdx.osdl.net (8.13.1/8.13.1/Submit) id k8QLrvD8003237
	for linux-scsi@vger.kernel.org; Tue, 26 Sep 2006 14:53:57 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

At OSDL we have been running automated cross-compiles on the 
scsi-misc and scsi-rc-fixes trees and I thought it might be 
helpful to post the warnings and errors which appear compared 
to the tree it is based on.  SCSI is clean, so mostly these 
are warnings.  We do allmodconfig or defconfig on arm, I386, 
ia64, powerpc, ppc, sparc64, x86_64.  If there were no 
additional warnings, then that architecture is not in this 
output.

So, below are the _additional_ warnings from the linux-2.6.18-scsi-misc1 
compile outputs when compared to the linux-2.6.18 compile outputs.

Let me know if this is useful, or how it could be better.

WKR,
Judith Lebzelter
OSDL



*********I386*********
> drivers/scsi/aacraid/commsup.c: In function '_aac_reset_adapter':
> drivers/scsi/aacraid/commsup.c:1112: warning: implicit declaration of function 'free_irq'
> WARNING: arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.o - Section mismatch: reference to .init.data:sw_any_bug_dmi_table from .text between 'acpi_cpufreq_cpu_init' (at offset 0x355) and 'acpi_cpufreq_target'
> WARNING: arch/i386/kernel/cpu/cpufreq/speedstep-centrino.o - Section mismatch: reference to .init.text: from .data between 'sw_any_bug_dmi_table' (at offset 0x40) and 'models'


*********ia64*********
> drivers/infiniband/hw/amso1100/c2_provider.c: In function `c2_reg_phys_mr':
> drivers/infiniband/hw/amso1100/c2_provider.c:397: warning: long long unsigned int format, long unsigned int arg (arg 6)
> drivers/infiniband/hw/amso1100/c2_provider.c:397: warning: long long unsigned int format, long unsigned int arg (arg 7)
> drivers/infiniband/hw/amso1100/c2_provider.c:397: warning: long long unsigned int format, long unsigned int arg (arg 8)
> drivers/infiniband/hw/amso1100/c2_rnic.c: In function `c2_rnic_init':
> drivers/infiniband/hw/amso1100/c2_rnic.c:529: warning: long long unsigned int format, dma_addr_t arg (arg 4)
> drivers/infiniband/hw/amso1100/c2_rnic.c:552: warning: long long unsigned int format, dma_addr_t arg (arg 4)
> drivers/infiniband/hw/amso1100/c2_alloc.c: In function `c2_alloc_mqsp':
> drivers/infiniband/hw/amso1100/c2_alloc.c:117: warning: long long unsigned int format, long unsigned int arg (arg 4)
> drivers/infiniband/hw/amso1100/c2_alloc.c:94: warning: 'mqsp' might be used uninitialized in this function
> drivers/infiniband/hw/amso1100/c2_ae.c: In function `c2_ae_event':
> drivers/infiniband/hw/amso1100/c2_ae.c:195: warning: long long unsigned int format, long unsigned int arg (arg 4)
> drivers/scsi/aacraid/commsup.c: In function `_aac_reset_adapter':
> drivers/scsi/aacraid/commsup.c:1112: warning: implicit declaration of function `free_irq'
> drivers/scsi/lpfc/lpfc_attr.c: In function `lpfc_soft_wwpn_show':
> drivers/scsi/lpfc/lpfc_attr.c:597: warning: long long unsigned int format, uint64_t arg (arg 4)
> drivers/scsi/lpfc/lpfc_attr.c:597: warning: long long unsigned int format, uint64_t arg (arg 4)
> net/dccp/ccids/ccid2.c: In function `ccid2_hc_tx_packet_sent':
> net/dccp/ccids/ccid2.c:355: warning: long long unsigned int format, u64 arg (arg 3)
> net/dccp/ccids/ccid2.c:360: warning: long long unsigned int format, u64 arg (arg 3)
> net/dccp/ccids/ccid2.c: In function `ccid2_new_ack':
> net/dccp/ccids/ccid2.c:482: warning: long long unsigned int format, u64 arg (arg 5)
> net/dccp/ccids/ccid2.c: In function `ccid2_hc_tx_packet_recv':
> net/dccp/ccids/ccid2.c:639: warning: long long unsigned int format, u64 arg (arg 3)
> net/dccp/ccids/ccid2.c:639: warning: long long unsigned int format, u64 arg (arg 4)
> net/dccp/ccids/ccid2.c:674: warning: long long unsigned int format, u64 arg (arg 3)
> net/dccp/ccids/ccid2.c:720: warning: long long unsigned int format, u64 arg (arg 3)


*********powerpc*********
> drivers/infiniband/hw/amso1100/c2_provider.c: In function 'c2_reg_phys_mr':
> drivers/infiniband/hw/amso1100/c2_provider.c:397: warning: format '%llx' expects type 'long long unsigned int', but argument 6 has type 'u64'
> drivers/infiniband/hw/amso1100/c2_provider.c:397: warning: format '%llx' expects type 'long long unsigned int', but argument 7 has type 'u64'
> drivers/infiniband/hw/amso1100/c2_provider.c:397: warning: format '%llx' expects type 'long long unsigned int', but argument 8 has type 'u64'
> drivers/infiniband/hw/amso1100/c2_rnic.c: In function 'c2_rnic_init':
> drivers/infiniband/hw/amso1100/c2_rnic.c:529: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'dma_addr_t'
> drivers/infiniband/hw/amso1100/c2_rnic.c:552: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'dma_addr_t'
> drivers/infiniband/hw/amso1100/c2_alloc.c: In function 'c2_alloc_mqsp':
> drivers/infiniband/hw/amso1100/c2_alloc.c:117: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'dma_addr_t'
> drivers/infiniband/hw/amso1100/c2_ae.c: In function 'c2_ae_event':
> drivers/infiniband/hw/amso1100/c2_ae.c:195: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'u64'
> drivers/scsi/aacraid/commsup.c: In function '_aac_reset_adapter':
> drivers/scsi/aacraid/commsup.c:1112: warning: implicit declaration of function 'free_irq'
> drivers/scsi/lpfc/lpfc_attr.c: In function 'lpfc_soft_wwpn_show':
> drivers/scsi/lpfc/lpfc_attr.c:597: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'uint64_t'
> drivers/scsi/lpfc/lpfc_attr.c:597: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'uint64_t'
> drivers/video/riva/fbdev.c: In function 'riva_get_EDID_OF':
> drivers/video/riva/fbdev.c:1846: warning: assignment discards qualifiers from pointer target type
> net/dccp/ccids/ccid2.c: In function 'ccid2_hc_tx_packet_sent':
> net/dccp/ccids/ccid2.c:355: warning: format '%llu' expects type 'long long unsigned int', but argument 3 has type 'u64'
> net/dccp/ccids/ccid2.c:360: warning: format '%llu' expects type 'long long unsigned int', but argument 3 has type 'u64'
> net/dccp/ccids/ccid2.c: In function 'ccid2_new_ack':
> net/dccp/ccids/ccid2.c:482: warning: format '%llu' expects type 'long long unsigned int', but argument 5 has type 'u64'
> net/dccp/ccids/ccid2.c: In function 'ccid2_hc_tx_packet_recv':
> net/dccp/ccids/ccid2.c:639: warning: format '%llu' expects type 'long long unsigned int', but argument 3 has type 'u64'
> net/dccp/ccids/ccid2.c:639: warning: format '%llu' expects type 'long long unsigned int', but argument 4 has type 'u64'
> net/dccp/ccids/ccid2.c:674: warning: format '%llu' expects type 'long long unsigned int', but argument 3 has type 'u64'
> net/dccp/ccids/ccid2.c:720: warning: format '%llu' expects type 'long long unsigned int', but argument 3 has type 'u64'


*********ppc*********
> drivers/net/3c509.c: In function 'el3_start_xmit':
> drivers/net/3c509.c:883: warning: implicit declaration of function 'outsl_ns'
> drivers/net/3c509.c: In function 'el3_rx':
> drivers/net/3c509.c:1107: warning: implicit declaration of function 'insl_ns'
> WARNING: "outsl_ns" [drivers/net/3c509.ko] undefined!
> WARNING: "insl_ns" [drivers/net/3c509.ko] undefined!


*********x86_64*********
> drivers/scsi/aacraid/commsup.c: In function '_aac_reset_adapter':
> drivers/scsi/aacraid/commsup.c:1112: warning: implicit declaration of function 'free_irq'
> WARNING: arch/x86_64/kernel/cpufreq/acpi-cpufreq.o - Section mismatch: reference to .init.data: from .text between 'acpi_cpufreq_cpu_init' (at offset 0x3da) and 'acpi_cpufreq_target'
> WARNING: arch/x86_64/kernel/cpufreq/speedstep-centrino.o - Section mismatch: reference to .init.text: from .data between 'sw_any_bug_dmi_table' (at offset 0x80) and 'centrino_attr'
