From: Scott Merritt <Scsi@PragmaSoft.com>
Subject: Re: Inhibit auto-attach of scsi disks ?
Date: Tue, 1 Oct 2002 22:45:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021001224524.29d5df36.Scsi@PragmaSoft.com>
References: <20021001080115.A27028@eng2.beaverton.ibm.com>
	<200210011514.g91FEC703750@localhost.localdomain>
	<20021001161819.36c43d89.Scsi@PragmaSoft.com>
	<1033519584.20103.38.camel@irongate.swansea.linux.org.uk>
	<20021001214937.6eebe5d2.Scsi@PragmaSoft.com>
	<20021002015838.GE29093@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021002015838.GE29093@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 1 Oct 2002 21:58:38 -0400
Doug Ledford <dledford@redhat.com> wrote:

> You are confusing auto attachment with auto mounting.  When you do the low 
> level things you suggest, the disk should not be *mounted* but it *must* 
> be attached (or else there won't be a scsi device for you to open and tell 
> to format itself for instance).

Yes, I would certainly agree that the scsi disk must first be "attached".  However, I'm not entirely clear on the need to *always* read/parse the partition table as an integral part of "attaching" the scsi disk.

Assuming that I understand you correctly, I think this is simply a slightly different "artistic" view.  Under the assumption that an "early" read of the partition table does no "damage", there is clearly no compelling reason to change.  About the best argument I could come up with is some type of hypothetical disk device that would appreciate a firmware/parameter download from the "main" filesystem before being forced to perform it's first data operation.  An admittedly tenuous example ... :)

Best regards, Scott.



