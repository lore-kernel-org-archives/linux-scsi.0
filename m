From: Simon Burley <simonb@lipsyncpost.co.uk>
Subject: Re: Pb between an UltraTrak SX8000 and an Adaptec 29160
Date: Wed, 20 Nov 2002 15:22:16 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DDBA8A8.F370532E@lipsyncpost.co.uk>
References: <000501c28f02$934b3000$13e2cf82@darkwolf> <1037626683.7486.10.camel@irongate.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: didier@ece.gatech.edu, "'Justin T. Gibbs'" <gibbs@scsiguy.com>, linux-scsi@vger.kernel.org

Alan Cox wrote:

<snip>

> Linux 2.4.x doesnt support single volumes over 1Tb. Thats fixed in 2.5

Can I ask what the symptoms of this failure to support >1Tb volumes
would be? Failure to identify the device? Random read/write failures?
Completely corrupted disk? It's the first time I've heard this!

The reason I ask is because we have a Storcase IDE to SCSI raid
enclosure with RAID controller here containing 8x Maxtor 160Gb disks
(configured as one RAID 3 volume), and it has been 100% reliable since
day one. No strangeness, failures of any sort, errors in syslog etc.

Vendor: DS570     Model:                   Rev: 0001
Type:   Direct-Access                      ANSI SCSI revision: 03
scsi2:A:6:0: Tagged Queuing enabled.  Depth 253

(scsi2:A:6): 160.000MB/s transfers (80.000MHz DT, offset 31, 16bit)
SCSI device sdb: -2053816320 512-byte hdwr sectors (47958 MB)

So I see the same problem as Didier, but fdisk version 2.11f got the
size right under 2.4.19-ac4:

df -kl
Filesystem           1k-blocks      Used Available Use% Mounted on
/dev/sdb1            1102989912 847397312 199563908  81% /local


Or am I missing something?

Simon
