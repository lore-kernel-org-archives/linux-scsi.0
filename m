From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] removel useless mod use count manipulation
Date: Sun, 17 Nov 2002 23:40:43 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DD78E4B.6040006@torque.net>
References: <20021116204009.A24052@lst.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> There's a bunch of useless mod usecount handling in scsi:

While playing with scsi_debug today I saw the opposite effect:
with a file system mounted on a scsi_debug fake disk **, lsmod
showed a zero "in use" count. I was able to "rmmod scsi_debug"
and crash the system when I tried to access that mounted fs.


** A further problem I am seeing is building partitions with
fdisk (on scsi_debug [haven't tried a real disk]) that don't
get reflected in /proc/partitions . I can add a partition
to /dev/sda but 'mke2fs /dev/sda1' fails with "no such device".
BTW I can forget partitions and successfully work with the
whole disk (i.e. "mke2fs -F /dev/sda ; mount /dev/sda /mnt/x").
Lk 2.5.47 on RH8.0 system with fdisk from util-linux-2.11r-10 .

Doug Gilbert

