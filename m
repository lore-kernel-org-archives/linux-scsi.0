From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Hotplug does not work with Fusion MPT
Date: Mon, 15 May 2006 09:51:47 -0600
Message-ID: <20060515155147.GX12272@parisc-linux.org>
References: <664A4EBB07F29743873A87CF62C26D700F9E8E@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:31210 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S1751553AbWEOPvs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 May 2006 11:51:48 -0400
Content-Disposition: inline
In-Reply-To: <664A4EBB07F29743873A87CF62C26D700F9E8E@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: Maik Hampel <Maik.Hampel@xiranet.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, May 15, 2006 at 09:04:52AM -0600, Moore, Eric wrote:
> On Monday, May 15, 2006 7:44 AM, Matthew Wilcox wrote:
> > Did you tell Linux you removed it?  Try:
> > 
> > echo scsi remove-single-device 0 0 4 0 > /proc/scsi/scsi
> > 
> > Parallel SCSI doesn't have a way to notify the OS that a 
> > device is gone,
> > so the user has to say.
> 
> We have Hotplug device support in fustion drivers for SAS and Fibre, not
> for SPI.

Erm.  Are you saying it doesn't work?  Or you just don't test it?
If the user runs the above command, the host's ->slave_destroy is called.
The mptspi slave_destroy method looks like it works.  What's the problem?
