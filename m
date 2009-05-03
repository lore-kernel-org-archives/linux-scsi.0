From: Robert Hancock <hancockrwd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: 2.6.30-rc4 Weird messages with ext4
Date: Sun, 03 May 2009 14:39:33 -0600
Message-ID: <49FE0105.6010107@gmail.com>
References: <200905031508.06053.papadako@csd.uoc.gr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <200905031508.06053.papadako-YET4oHL9trYCep0kKqy/Kg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Panagiotis Papadakos <papadako-YET4oHL9trYCep0kKqy/Kg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Panagiotis Papadakos wrote:
> Hi.
> 
> When I connect my ext4 formatted Seagate 1.5 TB USB box,
> I get the messages of the style:
> 
> [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE           
> [sdb] Sense Key : Illegal Request [current]                     
> [sdb] Add. Sense: Logical block address out of range 
> 
> By the way I am not getting such messages with 2.6.29.
> 
> Anyone knows what might be wrong?

Sounds like something's messing up with the disk size detection, as it 
gets detected as a 2TB drive. CCing linux-usb and linux-scsi.

Apr 27 20:42:15 cray-7 kernel: [    7.600940] scsi 2:0:0:0: 
Direct-Access     ST315003 41AS                  PQ: 0 ANSI: 2
Apr 27 20:42:15 cray-7 kernel: [    7.601701] sd 2:0:0:0: Attached scsi 
generic sg2 type 0
Apr 27 20:42:15 cray-7 kernel: [    7.623420] sd 2:0:0:0: [sdb] Very big 
device. Trying to use READ CAPACITY(16).
Apr 27 20:42:15 cray-7 kernel: [    7.624694] sd 2:0:0:0: [sdb] Using 
0xffffffff as device size
Apr 27 20:42:15 cray-7 kernel: [    7.624703] sd 2:0:0:0: [sdb] 
4294967296 512-byte hardware sectors: (2.19 TB/2.00 TiB)
Apr 27 20:42:15 cray-7 kernel: [    7.627074] sd 2:0:0:0: [sdb] Write 
Protect is off
Apr 27 20:42:15 cray-7 kernel: [    7.649077] sd 2:0:0:0: [sdb] Very big 
device. Trying to use READ CAPACITY(16).
Apr 27 20:42:15 cray-7 kernel: [    7.650288] sd 2:0:0:0: [sdb] Using 
0xffffffff as device size
Apr 27 20:42:15 cray-7 kernel: [    7.652566]  sdb: unknown partition table
Apr 27 20:42:15 cray-7 kernel: [    7.674807] sd 2:0:0:0: [sdb] Attached 
SCSI disk
Apr 27 20:42:15 cray-7 kernel: [    7.683409] sd 2:0:0:0: [sdb] Result: 
hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 27 20:42:15 cray-7 kernel: [    7.683418] sd 2:0:0:0: [sdb] Sense 
Key : Illegal Request [current]
Apr 27 20:42:15 cray-7 kernel: [    7.683425] sd 2:0:0:0: [sdb] Add. 
Sense: Logical block address out of range
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
