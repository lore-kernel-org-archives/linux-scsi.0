From: Douglas Gilbert <dougg@torque.net>
Subject: Re: ide-scsi fails with kernels > 2.4.1
Date: Thu, 30 Jan 2003 21:24:46 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E38FD6E.9030509@torque.net>
References: <Pine.LNX.4.20.0301301047240.24862-100000@users.evp.sf.ukrtel.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrei Loukinykh <avl@seavenue.net>
Cc: linux-scsi@vger.kernel.org

Andrei Loukinykh wrote:
>  Hi all
>   Being a sort of god damn tired (sorry), i decided to ask here
> 
>  In short:
>    My CDRW refuses to work with any kernel bigger than 2.4.1.
> 
> It is IDE-CDRW . I use ide-scsi driver for this.
> With 2.4.1 - all o'k.
>  Then I tried 2.4.7 ... 2.4.9 ... 2.4.19.. 2.4.20 ( i dont remember al of
> them) - none works. I get the following:
> 
> hdc: SAMSUNG CD-R/RW SW-408B, ATAPI CD/DVD-ROM drive
> ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> ide1 at 0x170-0x177,0x376 on irq 15
> blk: queue c030e544, I/O limit 4095Mb (mask 0xffffffff)
> hda: 12672450 sectors (6488 MB), CHS=788/255/63, UDMA(33)
> hdc: set_drive_speed_status: status=0x51 { DriveReady SeekComplete Error }
> hdc: set_drive_speed_status: error=0x04
> 
> 
> Someone please help
>  I desperately need 2.4.20 for my devices to work, but I also need CDR..

Andrei,
Do either of these lines help?
     hdparm -d0 -c1 /dev/hdc
     hdparm -d 1 -X 34 /dev/hdc

For more information see the:
     http://www.torque.net/sg/faq.html
entry on cdrecord [item 3.2].

Hope this helps.

Doug Gilbert

