From: Scott Merritt <Scsi@PragmaSoft.com>
Subject: Re: Inhibit auto-attach of scsi disks ?
Date: Tue, 1 Oct 2002 21:49:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021001214937.6eebe5d2.Scsi@PragmaSoft.com>
References: <20021001080115.A27028@eng2.beaverton.ibm.com>
	<200210011514.g91FEC703750@localhost.localdomain>
	<20021001161819.36c43d89.Scsi@PragmaSoft.com>
	<1033519584.20103.38.camel@irongate.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1033519584.20103.38.camel@irongate.swansea.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Scsi@PragmaSoft.com, linux-scsi@vger.kernel.org


Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> You can do all those things while it is attached as a disk device.

Yes - my concerns are perhaps more "artistic" (and possibly misguided).  If I am mounting a disk for low level maintenance, it may not have a valid partition table and I may not appreciate the Syslog warnings related to the partition table.  Furthermore, all though I haven't investigated, it seems like it might be tricky to determine that I have altered the partition table and that /dev/sdb6 is no longer a valid partition.  To me, it just seemed that giving the user/administrator some way to control/inhibit the auto-attachment would be a "cleaner" solution to the problem - but that's just one man's opinion ... :)

Regards, Scott.
