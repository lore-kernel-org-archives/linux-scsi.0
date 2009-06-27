From: Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [PATCH] SCSI: userspace cannot use scsi_command_size_tbl,
 COMMAND_SIZE and scsi_device_type
Date: Sun, 28 Jun 2009 00:10:39 +0530
Message-ID: <1246128039.32198.17.camel@hpdv5.satnam>
References: <1246122359.32198.7.camel@hpdv5.satnam>
	 <1246123628.3990.19.camel@mulgrave.site>
	 <1246125388.32198.14.camel@hpdv5.satnam>
	 <20090627182821.GC5480@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757438AbZF0Slk@vger.kernel.org>
In-Reply-To: <20090627182821.GC5480@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Sam Ravnborg <sam@ravnborg.org>, Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@panasas.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Smart <James.Smart@Emulex.Com>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2009-06-27 at 12:28 -0600, Matthew Wilcox wrote:
> On Sat, Jun 27, 2009 at 11:26:28PM +0530, Jaswinder Singh Rajput wrote:
> > > On Sat, 2009-06-27 at 22:35 +0530, Jaswinder Singh Rajput wrote:
> > > > userspace cannot use scsi_command_size_tbl, COMMAND_SIZE
> > > > and scsi_device_type defined in kernel
> 
> When did we start exporting include/scsi to userspace?  I thought glibc
> had its own separate definitions.
> 

commit 9e4f5e29610162fd426366f3b29e3cc6e575b858
Author: James Smart <James.Smart@Emulex.Com>
Date:   Thu Mar 26 13:33:19 2009 -0400

    [SCSI] FC Pass Thru support

--
JSR
