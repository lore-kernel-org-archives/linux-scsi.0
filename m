From: "didier" <didier@ece.gatech.edu>
Subject: RE: Pb between an UltraTrak SX8000 and an Adaptec 29160
Date: Wed, 20 Nov 2002 08:53:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <000b01c2909c$28370eb0$13e2cf82@darkwolf>
References: <1037626683.7486.10.camel@irongate.swansea.linux.org.uk>
Reply-To: <didier@ece.gatech.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1037626683.7486.10.camel@irongate.swansea.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: 'Alan Cox' <alan@lxorguk.ukuu.org.uk>
Cc: "'Justin T. Gibbs'" <gibbs@scsiguy.com>, linux-scsi@vger.kernel.org




> Linux 2.4.x doesnt support single volumes over 1Tb. Thats fixed in 2.5

Doh. My mistake.

However I am still experiencing some weird behaviour even with small
Raid5 Array.

I have recreated a new Raid 5 array with 4 drives (size = 558GB,
CHS map = 72944/254/63).

Nov 20 08:38:49 dagdhasrv kernel: SCSI device sda: 1171874688 
                          512-byte hdwr sectors (-499511 MB)
                                                 ^^^^^^^^^^^
                                
Nov 20 08:38:49 dagdhasrv kernel:  sda: sda1

Nov 20 08:43:45 dagdhasrv kernel: ^INo terminal CRC packet recevied
Nov 20 08:43:45 dagdhasrv kernel: (scsi0:A:0:0): parity error detected
in Data-out phase. SEQADDR(0x8a) SCSIRATE(0xc2) 
Nov 20 08:43:45 dagdhasrv kernel: ^INo terminal CRC packet recevied
Nov 20 08:43:45 dagdhasrv kernel: (scsi0:A:0:0): parity error detected
in Data-out phase. SEQADDR(0x55) SCSIRATE(0xc2) 

Any idea ?

Thanks - Didier

