From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [BUG] x86_64 pci_map_sg modifies sg list - fails multiple
	map/unmaps
Date: 05 Jan 2004 21:14:45 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1073358887.2439.39.camel@mulgrave>
References: <200401051929.i05JTsM0000014248@mudpuddle.cs.wustl.edu.suse.lists.linux.kern
	 el> <20040105112800.7a9f240b.davem@redhat.com.suse.lists.linux.kernel>
	<p73brpi1544.fsf@verdi.suse.de> <20040105130118.0cb404b8.davem@redhat.com>
	<20040105223158.3364a676.ak@suse.de> <1073347548.2439.33.camel@mulgrave>
	<20040106040640.1d2bcbd8.ak@suse.de>
	<20040105190439.0a5f7370.davem@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:8171 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265339AbUAFDO4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Jan 2004 22:14:56 -0500
In-Reply-To: <20040105190439.0a5f7370.davem@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: "David S. Miller" <davem@redhat.com>
Cc: Andi Kleen <ak@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, gibbs@scsiguy.com

On Mon, 2004-01-05 at 21:04, David S. Miller wrote:
> On Tue, 6 Jan 2004 04:06:40 +0100
> Andi Kleen <ak@suse.de> wrote:
> 
> > It's ok. I fixed the code now[1] If you have other undocumented requirements
> > you should document them though, otherwise there may be more problems.
> > Since merging is disabled by default now it won't trigger anyways.
> 
> I totally agree with you Andi, not documenting this properly was an
> oversight and not intentional.

I'll go over the SCSI code and see if I spot any other lacunae in the
API.

James


