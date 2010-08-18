From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [BUG raid1] kernel BUG at drivers/scsi/scsi_lib.c:1113
Date: Wed, 18 Aug 2010 09:41:38 -0500
Message-ID: <1282142498.3035.17.camel@mulgrave.site>
References: <20100817220917.GA5268@Krystal> <4C6B097E.7060505@gmail.com>
	 <20100817223145.GC4641@Krystal>  <4C6BC72E.6040607@gmail.com>
	 <1282141930.3035.9.camel@mulgrave.site>  <4C6BEFD1.8010200@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50625 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753342Ab0HROlo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Aug 2010 10:41:44 -0400
In-Reply-To: <4C6BEFD1.8010200@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-scsi@vger.kernel.org, hch@lst.de, jaxboe@fusionio.com, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org

On Wed, 2010-08-18 at 16:36 +0200, Jiri Slaby wrote:
> On 08/18/2010 04:32 PM, James Bottomley wrote:
> >> James and Jens, could you take the two remaining (SCSI and BLOCK)?
> > 
> > Sure ... could you identify the email by subject, please? lkml.org seems
> > to be down this morning.
> 
> Sure:
> [PATCH v2] BLOCK: fix bio.bi_rw handling
> and
> [PATCH v2] SCSI: fix bio.bi_rw handling
> 
> You should have received one copy to your suse.de inbox, if everything
> worked.

Got it.  One of life's little ironies is that I couldn't immediately
locate it in the SCSI list because it was already queued for inclusion.

James


