From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: RE: Pb between an UltraTrak SX8000 and an Adaptec 29160
Date: 18 Nov 2002 13:38:03 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1037626683.7486.10.camel@irongate.swansea.linux.org.uk>
References: <000501c28f02$934b3000$13e2cf82@darkwolf>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <000501c28f02$934b3000$13e2cf82@darkwolf>
List-Id: linux-scsi@vger.kernel.org
To: didier@ece.gatech.edu
Cc: "'Justin T. Gibbs'" <gibbs@scsiguy.com>, linux-scsi@vger.kernel.org

On Mon, 2002-11-18 at 13:01, didier wrote:
> Nov 14 11:04:35 dagdhasrv kernel: (scsi0:A:0): 160.000MB/s transfers
> (80.000MHz DT, offset 62, 16bit)
> Nov 14 11:04:35 dagdhasrv kernel: SCSI device sda: -1951217920 512-byte
> hdwr sectors (100488 MB)
>                                                    ^^^^^^^^^^^
> Nov 14 11:04:35 dagdhasrv kernel: Partition check: 
> Nov 14 11:04:35 dagdhasrv kernel:  sda: sda1

Linux 2.4.x doesnt support single volumes over 1Tb. Thats fixed in 2.5

