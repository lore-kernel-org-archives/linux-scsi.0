From: Black_David@emc.com
Subject: RE: thin provisioned LUN support
Date: Sun, 9 Nov 2008 21:36:10 -0500
Message-ID: <9FA859626025B64FBC2AF149D97C944A8A6488@CORPUSMX80A.corp.emc.com>
References: <20081107120534.GO21867@kernel.dk> <1226072970.15281.46.camel@think.oraclecorp.com> <yq1r65na5ll.fsf@sermon.lab.mkp.net> <1226074002.8030.33.camel@localhost.localdomain> <1226074270.15281.50.camel@think.oraclecorp.com> <1226074710.8030.43.camel@localhost.localdomain> <1226078535.15281.63.camel@think.oraclecorp.com> <4914846C.5060103@redhat.com> <20081107183636.GB29717@mit.edu> <49148BDF.9050707@redhat.com> <20081107193503.GG29717@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mexforward.lss.emc.com ([128.222.32.20]:14784 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbYKJCoc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Nov 2008 21:44:32 -0500
Content-class: urn:content-classes:message
In-Reply-To: <20081107193503.GG29717@mit.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tytso@mit.edu, rwheeler@redhat.com
Cc: chris.mason@oracle.com, James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, jens.axboe@oracle.com, dwmw2@infradead.org, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, coughlan@redhat.com, matthew@wil.cx, Black_David@emc.com

Ted,

> On Fri, Nov 07, 2008 at 01:41:35PM -0500, Ric Wheeler wrote:
> >> Will we be able to query the device and find out its TRIM/UNMAP
> >> alignment requirements?  There is also a balance between
performance
> >> (at least if the concern is sending too many separate TRIM
commands)
> >> and giving the SSD more flexibility in its wear-leveling allocation
> >> decisions by sending TRIM commands sooner rather than later.
> >>
> > T10 is still working on the proposal for how to display unmap
related  
> > information for SCSI, so we don't even have a consistent way to find

> > this out today for this population.
> 
> Yeah, I know, the rhetorical question was mostly addressed at David
> Black.  :-)

Well, here's a real answer ... that should be coming in T10/08-149r5 as
an addition to the block device limits VPD page.  Sorry for the delay
- I probably ought to remind Ric not to start this sort of discussion
*during* the T10 meetings - in contrast to the kernel, my brain is far
less effective at multi-tasking  ;-).

FYI,
--David
