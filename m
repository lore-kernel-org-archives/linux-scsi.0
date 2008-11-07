From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: thin provisioned LUN support
Date: Fri, 07 Nov 2008 14:55:06 -0500
Message-ID: <yq1iqqz9uqt.fsf@sermon.lab.mkp.net>
References: <20081107120534.GO21867@kernel.dk>
	<1226072970.15281.46.camel@think.oraclecorp.com>
	<yq1r65na5ll.fsf@sermon.lab.mkp.net>
	<1226074002.8030.33.camel@localhost.localdomain>
	<1226074270.15281.50.camel@think.oraclecorp.com>
	<1226074710.8030.43.camel@localhost.localdomain>
	<1226078535.15281.63.camel@think.oraclecorp.com>
	<4914846C.5060103@redhat.com> <20081107183636.GB29717@mit.edu>
	<49148BDF.9050707@redhat.com> <20081107193503.GG29717@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:23443 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbYKGT4A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Nov 2008 14:56:00 -0500
In-Reply-To: <20081107193503.GG29717@mit.edu> (Theodore Tso's message of "Fri\, 7 Nov 2008 14\:35\:03 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Cc: Ric Wheeler <rwheeler@redhat.com>, Chris Mason <chris.mason@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <jens.axboe@oracle.com>, David Woodhouse <dwmw2@infradead.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>

>>>>> "Ted" == Theodore Tso <tytso@mit.edu> writes:

Ted> I thought ATA didn't have any TRIM alignment requirements, and
Ted> it's T10 that wants to add it to the SCSI side?

The current UNMAP proposal in SCSI doesn't have requirements either.

Array vendors, suddenly realizing all the work they have to do to
support this, are now talking about imposing additional constraints
(orthogonal to the UNMAP command set) because of limitations in their
existing firmware architectures.

It obviously much easier for the array vendors to export a Somebody
Elses Problem VPD page containing a constant than it is to fix
inherent limitations in their internal architecture.

We're trying to point out that that's an unacceptable cop out for
something that's clearly their problem to deal with.

My concern is that if we start doing the array people's homework at
the OS level they won't be inclined to fix their broken firmware
design.  Ever.

-- 
Martin K. Petersen	Oracle Linux Engineering
