From: Olaf Hering <olaf@aepfle.de>
Subject: Re: storvsc loops with No Sense messages
Date: Tue, 29 Jan 2013 19:56:00 +0100
Message-ID: <20130129185600.GA31738@aepfle.de>
References: <20130129152801.GA671@aepfle.de>
 <a120050e059c40c2a1d1be4eadc42dfd@SN2PR03MB061.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:42425 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab3A2S4J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jan 2013 13:56:09 -0500
Content-Disposition: inline
In-Reply-To: <a120050e059c40c2a1d1be4eadc42dfd@SN2PR03MB061.namprd03.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, Jan 29, KY Srinivasan wrote:

> I have not seen this. The SRB status indicates it is an illegal request; the command is WRITE_SAME. I will take a look.

I can ignore it like SET_WINDOW, and the installation proceeds.
Just a few messages in dmesg:

...
[  107.448281] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[  111.020383] sd 2:0:0:0: [sda] Unhandled error code
[  111.020913] sd 2:0:0:0: [sda]
[  111.021264] Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK
[  111.021791] sd 2:0:0:0: [sda] CDB:
[  111.022186] Write Same(10): 41 00 00 16 e3 a8 00 0f d8 00
[  111.024400] end_request: I/O error, dev sda, sector 1500072
[  111.025790] sda2: WRITE SAME failed. Manually zeroing.
[  112.936342] sd 2:0:0:0: [sda] Unhandled error code
[  112.937588] sd 2:0:0:0: [sda]
[  112.938429] Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK
[  112.939642] sd 2:0:0:0: [sda] CDB:
[  112.940550] Write Same(10): 41 00 00 16 f3 80 00 0f e0 00
[  112.945081] end_request: I/O error, dev sda, sector 1504128
[  112.946627] sda2: WRITE SAME failed. Manually zeroing.
[  113.495880] ISO 9660 Extensions: Microsoft Joliet Level 3
[  113.498959] ISO 9660 Extensions: RRIP_1991A
[  114.728274] sd 2:0:0:0: [sda] Unhandled error code
[  114.729540] sd 2:0:0:0: [sda]
[  114.730419] Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK
[  114.731670] sd 2:0:0:0: [sda] CDB:
[  114.732644] Write Same(10): 41 00 00 17 03 60 00 0f e0 00
[  114.737219] end_request: I/O error, dev sda, sector 1508192
[  114.739027] sda2: WRITE SAME failed. Manually zeroing.
[  116.512217] sd 2:0:0:0: [sda] Unhandled error code
[  116.513206] sd 2:0:0:0: [sda]
[  116.513947] Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK
[  116.515187] sd 2:0:0:0: [sda] CDB:
[  116.515983] Write Same(10): 41 00 00 17 13 40 00 0f e0 00
[  116.519547] end_request: I/O error, dev sda, sector 1512256
[  116.521011] sda2: WRITE SAME failed. Manually zeroing.
...

Olaf
