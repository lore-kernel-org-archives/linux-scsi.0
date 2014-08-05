From: "hch@infradead.org" <hch@infradead.org>
Subject: Re: Bad tag value in scsi-mq.4
Date: Tue, 5 Aug 2014 12:28:09 -0700
Message-ID: <20140805192809.GA971@infradead.org>
References: <2C438B34CAC8264398F5C7AF7411910A62ADCC73@G9W0731.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35385 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbaHET2L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Aug 2014 15:28:11 -0400
Content-Disposition: inline
In-Reply-To: <2C438B34CAC8264398F5C7AF7411910A62ADCC73@G9W0731.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Handzik, Joe" <joseph.t.handzik@hp.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>, "Scales, Webb" <webb.scales@hp.com>, "Teel, Scott Stacy" <scott.stacy.teel@hp.com>

On Tue, Aug 05, 2014 at 06:04:07PM +0000, Handzik, Joe wrote:
> Hey Christoph,
> 
> Using the scsi-mq.4 branch from git://git.infradead.org/users/hch/scsi.git, I'm getting a -1 returned from from scsi_cmnd->request->tag...very unsure why that would be. It happens without any drives attached to the controller, not sure if that's relevant in any way.

You're using the non-mq code path, in which tagging needs to be enabled,
does your driver call scsi_activate_tcq?

