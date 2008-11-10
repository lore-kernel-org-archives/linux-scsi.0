From: Black_David@emc.com
Subject: RE: thin provisioned LUN support
Date: Sun, 9 Nov 2008 21:44:42 -0500
Message-ID: <9FA859626025B64FBC2AF149D97C944A8A648B@CORPUSMX80A.corp.emc.com>
References: <20081107120534.GO21867@kernel.dk>	<1226072970.15281.46.camel@think.oraclecorp.com>	<yq1r65na5ll.fsf@sermon.lab.mkp.net>	<1226074002.8030.33.camel@localhost.localdomain>	<1226074270.15281.50.camel@think.oraclecorp.com>	<1226074710.8030.43.camel@localhost.localdomain>	<1226078535.15281.63.camel@think.oraclecorp.com>	<4914846C.5060103@redhat.com> <20081107183636.GB29717@mit.edu>	<49148BDF.9050707@redhat.com> <20081107193503.GG29717@mit.edu> <yq1iqqz9uqt.fsf@sermon.lab.mkp.net> <4914A6EF.9040701@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mexforward.lss.emc.com ([128.222.32.20]:15242 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbYKJCqR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Nov 2008 21:46:17 -0500
Content-class: urn:content-classes:message
In-Reply-To: <4914A6EF.9040701@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rwheeler@redhat.com, martin.petersen@oracle.com
Cc: tytso@mit.edu, chris.mason@oracle.com, James.Bottomley@hansenpartnership.com, jens.axboe@oracle.com, dwmw2@infradead.org, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, coughlan@redhat.com, matthew@wil.cx

> > Ted> I thought ATA didn't have any TRIM alignment requirements, and
> > Ted> it's T10 that wants to add it to the SCSI side?
> >
> > The current UNMAP proposal in SCSI doesn't have requirements either.
> 
> I think that is being actively debated & due to go out in the next 
> update. Not sure that it will matter much since vendors will not have 
> implemented it yet in their boxes (at least, not yet)....

Not exactly.  The UNMAP proposal will have no alignment requirements
but will also make it up to the device (array) to decide what to unmap.

I expect implementations to pick out the chunks that can be unmapped
from the ranges that are passed in, and ignore the partial chunks.
As noted in a previous message, the chunk size will be reported in a
VPD page.

Thanks,
--David
