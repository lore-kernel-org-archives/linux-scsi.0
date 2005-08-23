From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] minimal SAS transport class
Date: Tue, 23 Aug 2005 21:10:10 +1000
Message-ID: <430B0412.4040107@torque.net>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A40@xbl3.ma.emulex.com> <20050822045502.GA7147@lists.us.dell.com> <430A05F2.10009@adaptec.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:11917 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S932122AbVHWLKM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Aug 2005 07:10:12 -0400
In-Reply-To: <430A05F2.10009@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>, James.Smart@Emulex.Com, hch@lst.de, jejb@steeleye.com, ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

Luben Tuikov wrote:
> On 08/22/05 00:55, Matt Domsch wrote:
> 
>>On Sat, Aug 20, 2005 at 12:15:41AM -0400, James.Smart@Emulex.Com wrote:
>>
>>
>>>- There are some real challenges in supporting a udev-named boot
>>> device. For the most part, it's a distro issue, which is becoming
>>> better. PS: for $10, name a 2.6 distro that uses udev out
>>> of the box for disk names and its installation. For $10 more, 
>>> can it install/boot from one?
>>
>>
>>I won't get your $10, but RHEL4 has a mechanism to specify "install
>>onto BIOS disk N", where N is typically 80h (it's an int13 number,
>>what BIOS typically boots from).  EDD in anaconda handles the mapping
>>of BIOS disk number to /dev/whatever.
> 
> 
> Hi Matt!  How is it going?
> 
> I wonder, do you think it would advantageous to provide
> another label to a disk device which includes this mapping?
> 
> (This is in lieu to the "myriad of labels" notion I've been
> talking about recently, where vendors (BIOS, Dell, disk manufacturer,
> transport layer, etc, etc, etc.) provide yet another label.  This label
> is tacked to the LU (most commonly a disk, it is *not* an FS label.))
> 
> This way, user space, or whoever, can look up the LU (disk device)
> by a label, that label or whichever one.

A note on the subject of LU labels: recent SCSI disks from
Fujitsu, Hitachi and Maxtor (but I cannot confirm this
for Seagate disks) support the REPORT and SET DEVICE
IDENTIFIER SCSI commands. These use a non-volatile
area outside a disk's lba space in which a user can
write a label (with a max length of 16, 64 (min in current
draft) or 512 (max in current draft) bytes depending
on the vendor).

I believe recent ATA disks also have a similar area where
a disk label could be written by the OS/user.

Doug Gilbert
