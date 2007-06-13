From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: scsi_cmnd accessors issues
Date: Thu, 14 Jun 2007 00:41:22 +0900
Message-ID: <20070614004122T.fujita.tomonori@lab.ntt.co.jp>
References: <466EDFAC.9020104@panasas.com>
	<20070613202442F.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:48289 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758054AbXFMPlY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jun 2007 11:41:24 -0400
In-Reply-To: <20070613202442F.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp
Cc: bharrosh@panasas.com, linux-scsi@vger.kernel.org, ed.lin@promise.com, g.liakhovetski@gmx.de, James.Bottomley@SteelEye.com

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: scsi_cmnd accessors issues
Date: Wed, 13 Jun 2007 20:24:42 +0900

> > drivers/scsi/sym53c8xx_2/sym_glue.h
> > drivers/scsi/sym53c8xx_2/sym_glue.c
> 
> The patch was in my old bidi tree but seems that it's in neither
> scsi-misc nor scsi-pending. I'll resend this.

Oops, this is in scsi-pending tree.

Here's the summary.

---
o Not converted yet

> drivers/ata/libata-scsi.c
> drivers/firewire/fw-sbp2.c
> drivers/scsi/advansys.c
> drivers/scsi/psi240i.c
> drivers/scsi/aha1542.c
> drivers/scsi/fd_mcs.c
> drivers/scsi/in2000.c
> drivers/scsi/NCR5380.c
> drivers/scsi/qla1280.c
> drivers/scsi/seagate.c
> drivers/scsi/atp870u.c
> drivers/scsi/gdth.c
> drivers/scsi/ide-scsi.c
> drivers/scsi/ppa.c
> drivers/scsi/imm.c
> drivers/scsi/aha152x.c
> drivers/scsi/pcmcia/nsp_cs.c
> drivers/usb/image/microtek.c
> drivers/usb/storage/protocol.c
> drivers/usb/storage/transport.c
> drivers/usb/storage/shuttle_usbat.c
> drivers/usb/storage/sddr09.c
> drivers/usb/storage/freecom.c
> drivers/usb/storage/isd200.c


o In scsi-pending tree and waits for ACKs

> drivers/infiniband/ulp/srp/ib_srp.c
> drivers/scsi/sym53c8xx_2/sym_glue.h
> drivers/scsi/sym53c8xx_2/sym_glue.c
> drivers/scsi/ncr53c8xx.c
> drivers/scsi/ibmvscsi/ibmvscsi.c


o In scsi-pending tree and got the ACKs

> drivers/scsi/aacraid/aachba.c
> drivers/scsi/hptiop.c
> drivers/scsi/mesh.c
> drivers/scsi/esp_scsi.c
> drivers/scsi/dc395x.c


o Not in scsi-pending tree and waits for ACKs

> drivers/scsi/iscsi_tcp.c
> drivers/scsi/libiscsi.c
> drivers/infiniband/ulp/iser/iscsi_iser.c
> drivers/infiniband/ulp/iser/iser_initiator.c
> drivers/message/i2o/i2o_scsi.c


o Not in scsi-pending tree and got the ACKs

> drivers/scsi/ips.c


o In scsi-pending tree but not necessary now

> drivers/scsi/lpfc/lpfc_scsi.c

