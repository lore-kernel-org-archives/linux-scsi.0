From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: RFC: should we deprecate unmaintained isa-only drivers?
Date: Fri, 9 Jan 2015 20:44:30 +0100
Message-ID: <201501092044.30710.linux@rainbow-software.org>
References: <20141230160616.GA29149@infradead.org> <201501062327.28830.linux@rainbow-software.org> <20150107143432.GA6542@infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:48244 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781AbbAITpC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jan 2015 14:45:02 -0500
In-Reply-To: <20150107143432.GA6542@infradead.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Wednesday 07 January 2015 15:34:32 Christoph Hellwig wrote:
> On Tue, Jan 06, 2015 at 11:27:28PM +0100, Ondrej Zary wrote:
> > > note that the last two even drive the same hardware.  There is
> > > significant cruft in all these, so dropping them would help
> > > further maintainance of the SCSI midlayer.
> >
> > I think I have a AHA-1542B ISA card so I can fix the aha1542 driver.
>
> Can you simply test that it even works for now?  If that's the case
> add yourself to MAINTAINERS for it, and and convert it away from using
> scsi_module.c as a start so that we get rid of the 10 year deprecated
> old-style host registration.

Yes, it still works in 3.19-rc3:
[  691.940019] Configuring Adaptec (SCSI-ID 7) at IO:330, IRQ 11, DMA priority 7
[  691.942063] scsi host2: Adaptec 1542
[  691.943474] bounce: isa pool size: 16 pages
[  691.956495] scsi 2:0:0:0: Direct-Access     IBM      DORS-32160       WA0A PQ: 0 ANSI: 2
[  693.540016] sd 2:0:0:0: [sdb] 4226725 512-byte logical blocks: (2.16 GB/2.01 GiB)
[  693.571820] sd 2:0:0:0: [sdb] Write Protect is off
[  693.571911] sd 2:0:0:0: [sdb] Mode Sense: b3 00 00 08
[  693.587551] sd 0:0:0:0: Attached scsi generic sg0 type 0
[  693.590061] sd 2:0:0:0: Attached scsi generic sg1 type 0
[  693.593491] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  693.721206]  sdb: sdb1
[  693.856355] sd 2:0:0:0: [sdb] Attached SCSI disk


-- 
Ondrej Zary
