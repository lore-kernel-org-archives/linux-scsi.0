From: Scott Merritt <Scsi@PragmaSoft.com>
Subject: Inhibit auto-attach of scsi disks ?
Date: Tue, 1 Oct 2002 16:18:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021001161819.36c43d89.Scsi@PragmaSoft.com>
References: <20021001080115.A27028@eng2.beaverton.ibm.com>
	<200210011514.g91FEC703750@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200210011514.g91FEC703750@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


> patmans@us.ibm.com said:
> use of the block device (i.e. dd if=/dev/sda), and probably others. 

I've noticed (at least in LK 2.4.19) that the scsi system will automatically "attach" any scsi disk-type device that it finds while scanning the scsi bus for new devices.  This includes issuing read capacity commands and attempting to read and parse that device's partition table.

I was wondering if there has been any discussion of a method/option by which a user could inhibit the automatic attachment of disk units ?  This might be desired if the users intent was to reformat, repartition, or perform other low-level activities.

Thanks, Scott.

