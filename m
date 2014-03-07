From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 2/3] Add EVPD page 0x83 to sysfs
Date: Fri, 7 Mar 2014 10:39:41 +0000
Message-ID: <1394188779.5225.40.camel@dabdike>
References: <1392286032-85036-1-git-send-email-hare@suse.de>
	 <1392286032-85036-3-git-send-email-hare@suse.de>
	 <20140228170131.GA31510@infradead.org> <5316D459.6070107@suse.de>
	 <20140305194255.GA5607@infradead.org> <53183951.7080805@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:34991 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbaCGKkB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Mar 2014 05:40:01 -0500
In-Reply-To: <53183951.7080805@suse.de>
Content-Language: en-US
Content-ID: <7C09DF6FBF054A42A83F6026DCC922CD@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "jlinton@tributary.com" <jlinton@tributary.com>, "dgilbert@interlog.com" <dgilbert@interlog.com>, "kay@vrfy.org" <kay@vrfy.org>, "kai.makisara@kolumbus.fi" <kai.makisara@kolumbus.fi>

On Thu, 2014-03-06 at 10:01 +0100, Hannes Reinecke wrote:
> So the only 'proper' solution would be to add a bitmap of supported
> pages; however, this would be 256 bits = 32 bytes of additional
> space required for struct sdev.
> Which I'm a bit reluctant do to, as it'll be a sparse array in most
> cases, adding to quite some wasted space.

Why per sdev?  Isn't it per target?  The supported EVPD page list
shouldn't really vary for luns of the same target unless something very
strange is happening in the array.

James

