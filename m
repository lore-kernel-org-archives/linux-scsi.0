From: Jeff Garzik <jgarzik@pobox.com>
Subject: blktool git repo created
Date: Tue, 25 Oct 2005 15:25:00 -0400
Message-ID: <435E868C.3010404@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Jens Axboe <axboe@suse.de>
List-Id: linux-scsi@vger.kernel.org


After sitting around in a non-public subversion repo for far too long, 
I've stuffed the latest blktool source code into a git repository.  As 
soon as it finished mirroring, it will be available at

rsync://rsync.kernel.org/pub/scm/linux/kernel/git/jgarzik/blktool.git

The ostensible home page of blktool is 
http://sourceforge.net/projects/gkernel/


What is it?

blktool is a multi-purpose tool that aims to a common place to 
management common block concepts, across a wide variety of hardware.

For example, rather than having to learn and use different tools for ATA 
or SCSI or I2O for the concept of "suspend", in the future one will 
simply do "blktool /dev/foo suspend" and it will work, regardless of 
what type of device it is.

I'm hoping that, as high level patterns emerge in storage, that blktool 
can grow to meet these needs.  For example, I would love to see blktool 
grow support for the various hardware RAID controllers out there, so 
that the admin need not learn a new raid management util for each 
controller.  James Bottomley's scsi-independent RAID class should help 
in this endeavor, as it matures.

	Jeff



