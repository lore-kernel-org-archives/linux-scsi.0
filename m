From: Christoph Hellwig <hch@infradead.org>
Subject: Re: FWD: [BK PATCH] SCSI host num allocation improvement
Date: Fri, 27 Feb 2004 12:48:42 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040227124842.B32109@infradead.org>
References: <1077842444.2662.123.camel@mulgrave> <20040227005601.GA6127@one-eyed-alien.net> <20040227010411.GB819@phunnypharm.org> <1077868581.4443.0.camel@laptop.fenrus.com> <20040227123009.GD4019@phunnypharm.org> <20040227123906.GB25779@parcelfarce.linux.theplanet.co.uk> <20040227124314.GF4019@phunnypharm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:9477 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262717AbUB0Msp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2004 07:48:45 -0500
Content-Disposition: inline
In-Reply-To: <20040227124314.GF4019@phunnypharm.org>; from bcollins@debian.org on Fri, Feb 27, 2004 at 07:43:15AM -0500
List-Id: linux-scsi@vger.kernel.org
To: Ben Collins <bcollins@debian.org>
Cc: Matthew Wilcox <willy@debian.org>, Arjan van de Ven <arjanv@redhat.com>, James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Feb 27, 2004 at 07:43:15AM -0500, Ben Collins wrote:
> > Yeah, we need to patch that warning out of the debian cdrecord packages.
> 
> Even still, if the real bus number is > 15, it doesn't recognize the device.

Sounds like cdrecord needs fixing.  Or even better replacing..

