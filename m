From: Andre Hedrick <andre@linux-ide.org>
Subject: RE: Pb between an UltraTrak SX8000 and an Adaptec 29160
Date: Mon, 18 Nov 2002 12:07:14 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.10.10211181205060.2779-100000@master.linux-ide.org>
References: <000501c28f02$934b3000$13e2cf82@darkwolf>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <000501c28f02$934b3000$13e2cf82@darkwolf>
List-Id: linux-scsi@vger.kernel.org
To: didier <didier@ece.gatech.edu>
Cc: "'Justin T. Gibbs'" <gibbs@scsiguy.com>, linux-scsi@vger.kernel.org


Didier,

I am waiting to close a contract to fix the problems w/ Promise products,
and yes I have the contract but have not signed the agreement to do the
work.  The issue is how they do their i2o v/s scsi.

Cheers,

Andre Hedrick
LAD Storage Consulting Group

On Mon, 18 Nov 2002, didier wrote:

> 
> 
> The UltraTrak was updated to the latest available firmware
> before connected to the server.
> 
> I e-mailed promise tech-support last week but did not get
> any answer so far.
> 
> On a different note, who should I contact regarding the display
> bug:
> 
> Nov 14 11:04:35 dagdhasrv kernel: (scsi0:A:0): 160.000MB/s transfers
> (80.000MHz DT, offset 62, 16bit)
> Nov 14 11:04:35 dagdhasrv kernel: SCSI device sda: -1951217920 512-byte
> hdwr sectors (100488 MB)
>                                                    ^^^^^^^^^^^
> Nov 14 11:04:35 dagdhasrv kernel: Partition check: 
> Nov 14 11:04:35 dagdhasrv kernel:  sda: sda1
> 
> Thanks again, Didier.
> 
> > > I have just connected a brand new UltraTrak SX8000
> > > (from Promise with 8 x 200GB IDE drives) to an
> > > adaptec 29160. The UltraTrak SX8000 is connected
> > > via a brand new LVD cable (1meter).
> > >
> > > While everything seems fine, I am getting a bunch of
> > >
> > > (scsi0:A:0:0): parity error detected in Data-out phase. 
> > SEQADDR(0x56)
> > > SCSIRATE(0xc2)
> > >         No terminal CRC packet recevied
> > 
> > I've never seen false positives from this diagnostic.  It 
> > looks like your Promise device is not properly implementing 
> > DT transfers.  Is there a firmware update for the device?
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

