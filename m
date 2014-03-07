From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] Add EVPD page 0x83 to sysfs
Date: Fri, 7 Mar 2014 02:11:18 -0800
Message-ID: <20140307101118.GA32333@infradead.org>
References: <1392286032-85036-1-git-send-email-hare@suse.de>
 <1392286032-85036-3-git-send-email-hare@suse.de>
 <20140228170131.GA31510@infradead.org>
 <5316D459.6070107@suse.de>
 <20140305194255.GA5607@infradead.org>
 <53183951.7080805@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39872 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbaCGKL1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Mar 2014 05:11:27 -0500
Content-Disposition: inline
In-Reply-To: <53183951.7080805@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Jeremy Linton <jlinton@tributary.com>, Kay Sievers <kay@vrfy.org>, Doug Gilbert <dgilbert@interlog.com>, Kai Makisara <kai.makisara@kolumbus.fi>

On Thu, Mar 06, 2014 at 10:01:05AM +0100, Hannes Reinecke wrote:
> I am somewhat reluctant here.
> 
> Adding separate flags like 'support_vpd_pg83' is a bit pointless,
> given that we might as well check for vpg_pg83.
> 
> So the only 'proper' solution would be to add a bitmap of supported
> pages; however, this would be 256 bits = 32 bytes of additional
> space required for struct sdev.
> Which I'm a bit reluctant do to, as it'll be a sparse array in most
> cases, adding to quite some wasted space.

Might want to keep it a local bitmap for now, but I suspect we'll
want it exposed sooner or later.

