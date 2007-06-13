From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: scsi_cmnd accessors issues
Date: Wed, 13 Jun 2007 20:24:42 +0900
Message-ID: <20070613202442F.fujita.tomonori@lab.ntt.co.jp>
References: <466EDFAC.9020104@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:62201 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446AbXFMPF2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jun 2007 11:05:28 -0400
In-Reply-To: <466EDFAC.9020104@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, ed.lin@promise.com, g.liakhovetski@gmx.de

From: Boaz Harrosh <bharrosh@panasas.com>
Subject: scsi_cmnd accessors issues
Date: Tue, 12 Jun 2007 21:02:20 +0300

Oops, I forgot to answer the status of lld conversion.

> [2]
> if I use __deprecated on request_buffer, request_bufflen, and use_sg with
> scsi_sgtable implementation Than I get below list of files complaining:
> drivers/ata/libata-scsi.c
> drivers/firewire/fw-sbp2.c

I've not converted yet.

> drivers/infiniband/ulp/srp/ib_srp.c

In scsi-pending tree and waits for ACKs.

> drivers/message/i2o/i2o_scsi.c

I've not converted yet.

> drivers/scsi/aacraid/aachba.c

In scsi-pending tree and got the ACK (will be moved to scsi-misc).

> drivers/scsi/lpfc/lpfc_scsi.c

In scsi-pending tree but Emulex reworked this patch. We can drop this.

> drivers/scsi/aha152x.c
> drivers/scsi/pcmcia/nsp_cs.c

I've not converted yet.

> drivers/scsi/sym53c8xx_2/sym_glue.h
> drivers/scsi/sym53c8xx_2/sym_glue.c

The patch was in my old bidi tree but seems that it's in neither
scsi-misc nor scsi-pending. I'll resend this.

> drivers/scsi/ncr53c8xx.c

In scsi-pending tree and waits for ACKs.

> drivers/scsi/advansys.c
> drivers/scsi/psi240i.c
> drivers/scsi/aha1542.c

I've not converted yet.

> drivers/scsi/ips.c

The maintainer pointed out that the initial patch has problems. I sent
an updated patch and waits for the ACK.

> drivers/scsi/fd_mcs.c
> drivers/scsi/in2000.c
> drivers/scsi/NCR5380.c
> drivers/scsi/qla1280.c
> drivers/scsi/seagate.c

I've not converted yet.

> drivers/scsi/dc395x.c

In scsi-pending tree and waits for ACKs.

> drivers/scsi/atp870u.c
> drivers/scsi/gdth.c
> drivers/scsi/ide-scsi.c
> drivers/scsi/ppa.c
> drivers/scsi/imm.c

I've not converted yet.

> drivers/scsi/hptiop.c

In scsi-pending tree and got ACKs (will be moved to scsi-misc).

> drivers/usb/image/microtek.c
> drivers/usb/storage/protocol.c
> drivers/usb/storage/transport.c
> drivers/usb/storage/shuttle_usbat.c
> drivers/usb/storage/sddr09.c
> drivers/usb/storage/freecom.c
> drivers/usb/storage/isd200.c

I've not converted yet.
