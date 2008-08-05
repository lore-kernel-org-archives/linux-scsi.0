From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: tools support for non-512 byte sector sizes
Date: Tue, 5 Aug 2008 10:57:15 -0600
Message-ID: <20080805165714.GB2055@parisc-linux.org>
References: <488F524F.6020905@redhat.com> <20080729182611.GB24924@parisc-linux.org> <1217356645.6103.48.camel@localhost.localdomain> <yq13alsr0g0.fsf@sermon.lab.mkp.net> <20080730135147.GA4513@auslistsprd01.us.dell.com> <20080801161149.GA26461@parisc-linux.org> <20080805165426.GA2055@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:56503 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762807AbYHEQ5Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Aug 2008 12:57:16 -0400
Content-Disposition: inline
In-Reply-To: <20080805165426.GA2055@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Jim Meyering <jim@meyering.net>, linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>

On Tue, Aug 05, 2008 at 10:54:27AM -0600, Matthew Wilcox wrote:
> On Fri, Aug 01, 2008 at 10:11:49AM -0600, Matthew Wilcox wrote:
> > Are they SCSI?  I just got round to trying 4k sector sizes in ata_ram
> > (after adding file backed capability) and found that libata currently
> > silently ignores the identify bits that report sector size.  I'll work
> > on fixing that this afternoon if nobody beats me to it.
> 
> OK, I have patches.  I'll send them to linux-ide.  If anyone wants to
> try them, I pushed out two trees; one for libata:
> 
> http://git.kernel.org/?p=linux/kernel/git/willy/misc.git;a=shortlog;h=ata-large-sectors
> 
> and one for ata_ram supporting:
>  - large sectors
>  - file backing
> http://git.kernel.org/?p=linux/kernel/git/willy/misc.git;a=shortlog;h=ata-ram

I forgot to mention ... I didn't add support for 520-byte (or 4104-byte
or 4160-byte) sectors.  Martin helpfully pointed me to
http://www.t13.org/Documents/UploadedDocuments/docs2008/e07162r2-External_Path_Protection.pdf
but it seems like T13 haven't allocated some words for this yet.  If
anyone wants to work on this, please contact me; I have some thoughts.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
