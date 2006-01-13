From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] mpt fusion - add support for fibre channel FC949ES
Date: Fri, 13 Jan 2006 11:19:53 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F1AA5A3@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:48270 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1422795AbWAMSUP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 13:20:15 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Michael Reed <mdr@sgi.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Friday, January 13, 2006 11:11 AM, Christoph Hellwig wrote: 

> 
> On Thu, Jan 12, 2006 at 04:55:01PM -0600, Michael Reed wrote:
> > Add software recognition for the new LSI Logic Fibre 
> Channel controller.
> > (Patch originally sent to me by Eric Moore.)
> 
> don't you need to add it to the pci_ids table aswell?
> 

Yes, that is required.

I was just talking to Micheal, and I've asked him to do
is not supply the 949ES support with his fc transport patch.
We had that discussion earlier this morning after the email
you sent asking for some additional cleanups.  Once Micheal reposts,
I plan to do a followon post that has all the 949ES bits.  It will
require updated MPI headers v1.5.12 as well, becuase one of the
required defines in mptbase.c are in the new headers.

