From: Christoph Hellwig <hch@infradead.org>
Subject: Re: qlogicfc bug
Date: Mon, 5 Jan 2004 14:36:21 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040105143621.A1569@infradead.org>
References: <A979D299E02AD31188EA0000834A03D2087582B7@S64P17BIA40>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:6660 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S264454AbUAEOgX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Jan 2004 09:36:23 -0500
Content-Disposition: inline
In-Reply-To: <A979D299E02AD31188EA0000834A03D2087582B7@S64P17BIA40>; from ext.devoteam.varoqui@sncf.fr on Mon, Jan 05, 2004 at 03:29:49PM +0100
List-Id: linux-scsi@vger.kernel.org
To: EXT / DEVOTEAM VAROQUI Christophe <ext.devoteam.varoqui@sncf.fr>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Mon, Jan 05, 2004 at 03:29:49PM +0100, EXT / DEVOTEAM VAROQUI Christophe wrote:
> Hello,
> 
> here is the kernel output of a bug in qlogicfc portdb.
> Output is truncated, but I can't do better : the server hangs hard.
> 
> Context :
> Server with 2 qlogic 2200 connected to a storageworks array eva5000 through
> silkworm 3800.
> Kernel is 2.6.0-mm2 + unstable device mapper stuff for multipath.
> 
> Bug spawns when rebooting the active FC-RAID controler during streaming IO
> on a LUN.

The qlogicfc driver is extremly buggy.  I'd suggest using qlogic's driver
(http://sf.net/projects/linux-qla2xxx) instead.  It's planned to merge
that driver into the kernel tree and replace qlogicfs once a few smaller
issues are worked out. 

