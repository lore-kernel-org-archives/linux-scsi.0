From: "Claudio Coppari" <c.coppari@sintekno.it>
Subject: How can I know the status of a MegaRAID Array?
Date: Mon, 6 Feb 2006 10:15:23 +0100
Message-ID: <9B432F84A0C6FD488F8736A5DFC10DB44DCE35@mail.sintek.ita>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host242-129.pool82104.interbusiness.it ([82.104.129.242]:49294
	"EHLO mail.sintek.ita") by vger.kernel.org with ESMTP
	id S1750811AbWBFJOH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2006 04:14:07 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,
I have a Fujitsu Siemens Primergy RX200 with Fedora Core 3 installed (Kernel 2.6.12-1.1381_FC3smp).
The machine is equipped with the following SCSI devices:

Attached devices:
Host: scsi0 Channel: 00 Id: 08 Lun: 00
  Vendor: SDR      Model: GEM318P          Rev: 1   
  Type:   Processor                        ANSI SCSI revision: 02
Host: scsi0 Channel: 01 Id: 00 Lun: 00
  Vendor: MegaRAID Model: LD0 RAID1 34700R Rev: 1F34
  Type:   Direct-Access                    ANSI SCSI revision: 02

I have installed 2 HDs with RAID 1 and it seems to work well.
My question is: how can I know if one disk fails?
Is there something link /proc/mdstat ?
Alternatively: if one disk fail any message will be written to the log files?

Thank you very much for your support!

Claudio
