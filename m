From: Ric Wheeler <rwheeler@redhat.com>
Subject: tools support for non-512 byte sector sizes
Date: Tue, 29 Jul 2008 13:24:31 -0400
Message-ID: <488F524F.6020905@redhat.com>
Reply-To: rwheeler@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Cc: Jim Meyering <jim@meyering.net>
List-Id: linux-scsi@vger.kernel.org


Jim pinged me about the use case for having our tool chain (parted 
specifically) support devices with non-512 bytes sectors.

Off the top of my head, the following is the list of existing or soon to 
appear devices that could use this (taken from our thread last year, at
http://kerneltrap.org/mailarchive/linux-fsdevel/2007/3/11/317183):

    (1) R/W optical drives
    (2) S390 dasd devices have a 4096 byte sector
    (3) new 4096 byte disks (which intend to export a virtual 512 byte 
sector)

Anything else pop into mind? Any idea if SSD or FLASH devices have 
thoughts to use a non-512 byte sector size? What tools are most critical 
to support?

Thanks!

Ric

