From: "Raz Ben-Yehuda" <razb@bitband.com>
Subject: RE: Intel X25-M MLC SSD benchmarks
Date: Fri, 12 Dec 2008 14:21:48 +0200
Message-ID: <83CA05F64804AF43B8F733C4ABDFAA51022D04DB@mail1.bitband.com>
References: <311601c90812111927t54ed6a54oac3154dba30f737d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-ide-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <311601c90812111927t54ed6a54oac3154dba30f737d@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: "Eric D. Mudama" <edmudama@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



-----Original Message-----
From: Eric D. Mudama [mailto:edmudama@gmail.com] 
Sent: Friday, December 12, 2008 5:28 AM
To: Raz Ben-Yehuda
Cc: Matthew Wilcox; linux-ide@vger.kernel.org;
linux-scsi@vger.kernel.org
Subject: Re: Intel X25-M MLC SSD benchmarks

On 12/10/08, Raz Ben-Yehuda <razb@bitband.com> wrote:
> All gave same results for most dd writes commands.
> dd if=/dev/zero of=/dev/sda bs=1M count=1000 oflag=direct , and many
> other variants such erase block size ( 128K ) , several erase block
size
> and so on. Kernel is 2.6.18-8.el5.
> I used all on a supermicro 1025W-UR. Disks have a SAS interface, 80GB.
> Also, I would like to note, I have 8 disks in array, while each one
> perform READS 250 MB/s, together I degrade to 200 MB/s each. As for
> writes I always reach 20 MB/s at best, from a single disk or 20x8 in
> array.

>>Out of curiosity, is write cache enabled or disabled on these devices?
Does not matter. In both cases same low numbers. Write cache depends on
the controller defaults ( Adpaptec AHCI, Intel provides different
default).

