From: "didier" <didier@ece.gatech.edu>
Subject: RE: Pb between an UltraTrak SX8000 and an Adaptec 29160
Date: Mon, 18 Nov 2002 08:01:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <000501c28f02$934b3000$13e2cf82@darkwolf>
References: <47810000.1037389984@localhost>
Reply-To: <didier@ece.gatech.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <47810000.1037389984@localhost>
List-Id: linux-scsi@vger.kernel.org
To: "'Justin T. Gibbs'" <gibbs@scsiguy.com>, linux-scsi@vger.kernel.org



The UltraTrak was updated to the latest available firmware
before connected to the server.

I e-mailed promise tech-support last week but did not get
any answer so far.

On a different note, who should I contact regarding the display
bug:

Nov 14 11:04:35 dagdhasrv kernel: (scsi0:A:0): 160.000MB/s transfers
(80.000MHz DT, offset 62, 16bit)
Nov 14 11:04:35 dagdhasrv kernel: SCSI device sda: -1951217920 512-byte
hdwr sectors (100488 MB)
                                                   ^^^^^^^^^^^
Nov 14 11:04:35 dagdhasrv kernel: Partition check: 
Nov 14 11:04:35 dagdhasrv kernel:  sda: sda1

Thanks again, Didier.

> > I have just connected a brand new UltraTrak SX8000
> > (from Promise with 8 x 200GB IDE drives) to an
> > adaptec 29160. The UltraTrak SX8000 is connected
> > via a brand new LVD cable (1meter).
> >
> > While everything seems fine, I am getting a bunch of
> >
> > (scsi0:A:0:0): parity error detected in Data-out phase. 
> SEQADDR(0x56)
> > SCSIRATE(0xc2)
> >         No terminal CRC packet recevied
> 
> I've never seen false positives from this diagnostic.  It 
> looks like your Promise device is not properly implementing 
> DT transfers.  Is there a firmware update for the device?

