From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: RE: Pb between an UltraTrak SX8000 and an Adaptec 29160
Date: 20 Nov 2002 14:33:02 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1037802782.3241.28.camel@irongate.swansea.linux.org.uk>
References: <000b01c2909c$28370eb0$13e2cf82@darkwolf>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <000b01c2909c$28370eb0$13e2cf82@darkwolf>
List-Id: linux-scsi@vger.kernel.org
To: didier@ece.gatech.edu
Cc: "'Justin T. Gibbs'" <gibbs@scsiguy.com>, linux-scsi@vger.kernel.org

On Wed, 2002-11-20 at 13:53, didier wrote:
> Nov 20 08:38:49 dagdhasrv kernel: SCSI device sda: 1171874688 
>                           512-byte hdwr sectors (-499511 MB)
>                                                  ^^^^^^^^^^^

That does look like a math bug in the driver but it would only mess up
printing.

> Nov 20 08:43:45 dagdhasrv kernel: ^INo terminal CRC packet recevied
> Nov 20 08:43:45 dagdhasrv kernel: (scsi0:A:0:0): parity error detected
> in Data-out phase. SEQADDR(0x8a) SCSIRATE(0xc2) 
> Nov 20 08:43:45 dagdhasrv kernel: ^INo terminal CRC packet recevied
> Nov 20 08:43:45 dagdhasrv kernel: (scsi0:A:0:0): parity error detected
> in Data-out phase. SEQADDR(0x55) SCSIRATE(0xc2) 

and this still appears to be broken hardware

