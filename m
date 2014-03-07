From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] Add EVPD page 0x83 to sysfs
Date: Fri, 7 Mar 2014 02:44:50 -0800
Message-ID: <20140307104450.GB28472@infradead.org>
References: <1392286032-85036-1-git-send-email-hare@suse.de>
 <1392286032-85036-3-git-send-email-hare@suse.de>
 <20140228170131.GA31510@infradead.org>
 <5316D459.6070107@suse.de>
 <20140305194255.GA5607@infradead.org>
 <53183951.7080805@suse.de>
 <20140307101118.GA32333@infradead.org>
 <5319A0F6.8000100@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40037 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbaCGKow (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Mar 2014 05:44:52 -0500
Content-Disposition: inline
In-Reply-To: <5319A0F6.8000100@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Jeremy Linton <jlinton@tributary.com>, Kay Sievers <kay@vrfy.org>, Doug Gilbert <dgilbert@interlog.com>, Kai Makisara <kai.makisara@kolumbus.fi>

On Fri, Mar 07, 2014 at 11:35:34AM +0100, Hannes Reinecke wrote:
> Agree. But for now I'd like to keep it as it is (ie without bitmap);
> there is no real benefit for just the two pages we're exposing right
> now.

Feel free to go ahead as-is.  We'll probably have to change it again
soon, but we might aswell just keep it for now.

