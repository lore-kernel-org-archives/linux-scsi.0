From: Gregoire Favre <Gregoire.Favre@freesurf.ch>
Subject: Only multiple lun for one device?
Date: Sat, 10 Apr 2004 14:22:20 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040410122154.GA23394@magma.epfl.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail3.epfl.ch ([128.178.50.19]:10760 "HELO mail3.epfl.ch")
	by vger.kernel.org with SMTP id S262009AbUDJMWX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Apr 2004 08:22:23 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I have some devices on my computer which uses SCSI, and only one which
need multiple lun, so I have to enable multiple lun in kernel which slw
down the boot process a lot...

usb 1-4: device not accepting address 2, error -71
usb 1-4: new high speed USB device using address 3
scsi2 : SCSI emulation for USB Mass Storage devices
  Vendor: SMSC      Model: USB 2 HS-CF       Rev: 1.97
  Type:   Direct-Access                      ANSI SCSI revision: 02
Attached scsi removable disk sdc at scsi2, channel 0, id 0, lun 0
Attached scsi generic sg5 at scsi2, channel 0, id 0, lun 0,  type 0
  Vendor: SMSC      Model: USB 2 HS-MS       Rev: 1.97
  Type:   Direct-Access                      ANSI SCSI revision: 02
Attached scsi removable disk sdd at scsi2, channel 0, id 0, lun 1
Attached scsi generic sg6 at scsi2, channel 0, id 0, lun 1,  type 0
  Vendor: SMSC      Model: USB 2 HS-SM       Rev: 1.97
  Type:   Direct-Access                      ANSI SCSI revision: 02
Attached scsi removable disk sde at scsi2, channel 0, id 0, lun 2
Attached scsi generic sg7 at scsi2, channel 0, id 0, lun 2,  type 0
  Vendor: SMSC      Model: USB 2 HS-SD/MMC   Rev: 1.97
  Type:   Direct-Access                      ANSI SCSI revision: 02
Attached scsi removable disk sdf at scsi2, channel 0, id 0, lun 3
Attached scsi generic sg8 at scsi2, channel 0, id 0, lun 3,  type 0
USB Mass Storage device found at 3

Is there a way to enable multiple lun only for the 8-1 cards readers?

Please CC to me as I am not on this ml :-)

Thank you very much,

	Gr=E9goire
_______________________________________________________________________=
___
http://algebra.epfl.ch/greg ICQ:16624071 mailto:Gregoire.Favre@freesurf=
=2Ech
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
