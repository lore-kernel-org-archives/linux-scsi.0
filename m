From: Gary_Lerhaupt@Dell.com
Subject: Determining the UUID of a USB storage device
Date: Thu, 22 Aug 2002 17:19:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20BF5713E14D5B48AA289F72BD372D6812BB32@AUSXMPC122.aus.amer.dell.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I am attempting to glean some sort of a unique identifier from a USB storage
device.  As it should, the storage shows up as a SCSI disk in
/proc/partitions and subsequent SCSI inquiries sent to it return a page 80
serial number.  However, it is apparent that this serial number is actually
the serial number of my ZIO! smartmedia reader and not of the actual card in
the reader.

Similarly, I am attempting to do the same thing with a firewire/IDE hard
drive reader.  This also is presented as a SCSI disk and again, the serial #
that I come up with is coming from the drive reader and not from the actual
disk.  I know if I were to install this IDE drive directly, I'd be able to
get the serial# from /proc/ide/hd#/identify, but obviously this is not so
easy to get to when attached the SCSI/firewire way.

Any thoughts?  Is it possible to tunnel through the SCSI stuff to get to the
real serial numbers that I'm looking for?

Gary Lerhaupt

