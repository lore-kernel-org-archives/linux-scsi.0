From: Andreas Schwab <schwab@suse.de>
Subject: Symbios 53C8XX broken on ia64?
Date: Tue, 23 Mar 2004 01:01:19 +0100
Sender: linux-ia64-owner@vger.kernel.org
Message-ID: <je3c80ph2o.fsf@sykes.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ia64-owner@vger.kernel.org>
To: linux-ia64@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Has anyone been able to get the sym53c8xx_2 driver in 2.6.5-rc2 working=
 on
HP zx1?  On the machines I tried it does not find any disks anymore.  T=
his
has been working fine with 2.6.3.

CONFIG_SCSI_SYM53C8XX_2=3Dm
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=3D1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=3D16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=3D64
# CONFIG_SCSI_SYM53C8XX_IOMAPPED is not set

Andreas.

--=20
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux AG, Maxfeldstra=DFe 5, 90409 N=FCrnberg, Germany
Key fingerprint =3D 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
-
To unsubscribe from this list: send the line "unsubscribe linux-ia64" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
