From: Manish RATHI <manish.rathi@st.com>
Subject: RE: scsi problem with usb
Date: Fri, 18 Aug 2006 18:36:14 +0530
Message-ID: <000601c6c2c7$15e09cc0$802cc70a@dlh.st.com>
References: <646765f40608180506x56854c84h1925066cd7729fc0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fra-del-02.spheriq.net ([195.46.51.98]:11484 "EHLO
	fra-del-02.spheriq.net") by vger.kernel.org with ESMTP
	id S1751293AbWHRNGZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Aug 2006 09:06:25 -0400
Received: from fra-out-02.spheriq.net (fra-out-02.spheriq.net [195.46.51.130])
        by fra-del-02.spheriq.net with ESMTP id k7ID6Lbg003534
        for <linux-scsi@vger.kernel.org>; Fri, 18 Aug 2006 13:06:21 GMT
Received: from fra-cus-01.spheriq.net (fra-cus-01.spheriq.net [195.46.51.37])
        by fra-out-02.spheriq.net with ESMTP id k7ID6JAi022152
        for <linux-scsi@vger.kernel.org>; Fri, 18 Aug 2006 13:06:20 GMT
In-Reply-To: <646765f40608180506x56854c84h1925066cd7729fc0@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Julian Calaby' <julian.calaby@gmail.com>
Cc: linux-scsi@vger.kernel.org

Hi,
It doesn't work with /dev/sda1 or /dev/sda2, sda3, sdb, sdc1, sdb1


brw-r--r--    1 root     root       8,   0 Aug 14  2006 sda
brw-r--r--    1 root     root       8,   1 Aug 14  2006 sda1
brw-r--r--    1 root     root       8,   2 Aug 14  2006 sda2
brw-r--r--    1 root     root       8,  16 Aug 14  2006 sdb
brw-r--r--    1 root     root       8,  17 Aug 17  2006 sdb1
brw-r--r--    1 root     root       8,  18 Aug 17  2006 sdb2
brw-r--r--    1 root     root       8,  32 Aug 14  2006 sdc
brw-r--r--    1 root     root       8,  33 Aug 17  2006 sdc1
brw-r--r--    1 root     root       8,  34 Aug 17  2006 sdc2
brw-r--r--    1 root     root       8,  35 Aug 17  2006 sdc3
brw-r--r--    1 root     root       8,  36 Aug 17  2006 sdc4
crw-r--r--    1 root     root      21,   0 Aug 14  2006 sg0
crw-r--r--    1 root     root      21,   3 Aug 14  2006 sg3

I am able to run fdisk and mkdosfs on /dev/sdb but again mount fail with "No
such device"

Thanks
Regards
Manish

-----Original Message-----
From: Julian Calaby [mailto:julian.calaby@gmail.com] 
Sent: Friday, August 18, 2006 5:36 PM
To: Manish RATHI
Cc: linux-scsi@vger.kernel.org
Subject: Re: scsi problem with usb


On 8/14/06, Manish RATHI <manish.rathi@st.com> wrote:
> However when I try to mount by
> Mount -t vfat /dev/sda /mnt/pendrive then
> I get error "Mounting /dev/sda on /mems failed: No such device" I 
> tried it on sdb and sdc as well but it's not mounted.
>
> I also tried to run fdisk /dev/sda but same type of error appears.

Try mounting using "/dev/sda1", rather than "/dev/sda".

The device "sda" is the *entire* disk, "sda1" is the first partition on it -
this will contain your data.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com

