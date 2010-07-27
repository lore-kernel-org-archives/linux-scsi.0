From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: scsi-next fail to be compiled
Date: Tue, 27 Jul 2010 14:04:06 -0500
Message-ID: <1280257446.2833.268.camel@mulgrave.site>
References: <4C4F2BC0.6030905@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:49476 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648Ab0G0TEP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jul 2010 15:04:15 -0400
In-Reply-To: <4C4F2BC0.6030905@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Karen Higgins <karen.higgins@qlogic.com>, Andrew Vasquez <andrew.va>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2010-07-27 at 11:56 -0700, Yinghai Lu wrote:
> LD      drivers/scsi/built-in.o
> drivers/scsi/qla4xxx/built-in.o: In function `qla82xx_idc_unlock':
> (.text+0x8814): multiple definition of `qla82xx_idc_unlock'
> drivers/scsi/qla2xxx/built-in.o:(.text+0x2ea14): first defined here
> drivers/scsi/qla4xxx/built-in.o: In function `qla82xx_pci_config':
>      (.text+0x344e): multiple definition of `qla82xx_pci_config'
> drivers/scsi/qla2xxx/built-in.o:(.text+0x2cdfd): first defined here
> drivers/scsi/qla4xxx/built-in.o: In function `qla82xx_pci_mem_write_2M':
> (.text+0x9b15): multiple definition of `qla82xx_pci_mem_write_2M'
> drivers/scsi/qla2xxx/built-in.o:(.text+0x2f0fb): first defined here
> drivers/scsi/qla4xxx/built-in.o: In function `qla82xx_pci_get_crb_addr_2M':
> (.text+0x80c0): multiple definition of `qla82xx_pci_get_crb_addr_2M'
> drivers/scsi/qla2xxx/built-in.o:(.text+0x2c2ec): first defined here
> drivers/scsi/qla4xxx/built-in.o: In function `qla82xx_wr_32':
> (.text+0x88b3): multiple definition of `qla82xx_wr_32'
> drivers/scsi/qla2xxx/built-in.o:(.text+0x2d23a): first defined here
> drivers/scsi/qla4xxx/built-in.o: In function `qla82xx_pci_mem_read_2M':
> (.text+0x9620): multiple definition of `qla82xx_pci_mem_read_2M'
> drivers/scsi/qla2xxx/built-in.o:(.text+0x2eded): first defined here
> drivers/scsi/qla4xxx/built-in.o: In function `qla82xx_msix_rsp_q':
> (.text+0x7d24): multiple definition of `qla82xx_msix_rsp_q'
> drivers/scsi/qla2xxx/built-in.o:(.text+0x2caca): first defined here
> drivers/scsi/qla4xxx/built-in.o: In function `qla82xx_rd_32':
> (.text+0x8786): multiple definition of `qla82xx_rd_32'
> drivers/scsi/qla2xxx/built-in.o:(.text+0x2d14f): first defined here
> drivers/scsi/qla4xxx/built-in.o: In function `qla82xx_watchdog':
> (.text+0x14ea): multiple definition of `qla82xx_watchdog'
> drivers/scsi/qla2xxx/built-in.o:(.text+0x2de2f): first defined here
> drivers/scsi/qla4xxx/built-in.o: In function `qla82xx_load_risc':
> (.text+0xafd4): multiple definition of `qla82xx_load_risc'
> drivers/scsi/qla2xxx/built-in.o:(.text+0x313d8): first defined here
> drivers/scsi/qla4xxx/built-in.o: In function `qla82xx_crb_win_lock':
> (.text+0x8b29): multiple definition of `qla82xx_crb_win_lock'
> drivers/scsi/qla2xxx/built-in.o:(.text+0x2d1e4): first defined here
> drivers/scsi/qla4xxx/built-in.o: In function `qla82xx_intr_handler':
> (.text+0x7e9b): multiple definition of `qla82xx_intr_handler'
> drivers/scsi/qla2xxx/built-in.o:(.text+0x2e068): first defined here
> drivers/scsi/qla4xxx/built-in.o: In function `qla82xx_clear_drv_active':
> (.text+0x9333): multiple definition of `qla82xx_clear_drv_active'
> drivers/scsi/qla2xxx/built-in.o:(.text+0x2e027): first defined here
> drivers/scsi/qla4xxx/built-in.o: In function `qla82xx_disable_intrs':
> (.text+0x8947): multiple definition of `qla82xx_disable_intrs'
> drivers/scsi/qla2xxx/built-in.o:(.text+0x2dd7d): first defined here
> drivers/scsi/qla4xxx/built-in.o: In function `qla82xx_iospace_config':
> (.text+0x1266): multiple definition of `qla82xx_iospace_config'
> drivers/scsi/qla2xxx/built-in.o:(.text+0x2ce36): first defined here
> drivers/scsi/qla4xxx/built-in.o: In function `qla82xx_enable_intrs':
> (.text+0x8a39): multiple definition of `qla82xx_enable_intrs'
> drivers/scsi/qla2xxx/built-in.o:(.text+0x2ddd6): first defined here
> drivers/scsi/qla4xxx/built-in.o: In function `qla82xx_device_state_handler':
> (.text+0x9fff): multiple definition of `qla82xx_device_state_handler'
> drivers/scsi/qla2xxx/built-in.o:(.text+0x30ccb): first defined here
> drivers/scsi/qla4xxx/built-in.o: In function `qla82xx_idc_lock':
> (.text+0x8829): multiple definition of `qla82xx_idc_lock'
> drivers/scsi/qla2xxx/built-in.o:(.text+0x30c56): first defined here
> make[1]: *** [drivers/scsi/built-in.o] Error 1
> make: *** [drivers/scsi/] Error 2

This is because exactly the same functions appear in the qla2xxx/ and
qla4xxx/ directories

Qlogic people, please get this sorted out now, otherwise I'll drop the
qla4xxx update before sending to Linus

The best option would be to separate out the 82xx functions so that both
2xxx and 4xxx can use them.  In the interim, you could add a
discriminator prefix.

James


