From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 05/13] block: Export I/O topology for block devices and partitions
Date: Tue, 19 May 2009 12:41:53 -0400
Message-ID: <yq1fxf1gi3y.fsf@sermon.lab.mkp.net>
References: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com>
	<1242362435-11953-6-git-send-email-martin.petersen@oracle.com>
	<20090518175741.GM4140@kernel.dk> <20090518181204.GC32085@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:33780 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbZESQmQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 May 2009 12:42:16 -0400
In-Reply-To: <20090518181204.GC32085@redhat.com> (Mike Snitzer's message of
	"Mon, 18 May 2009 14:12:05 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

>> I really hate the 'alignment' name, nobody will know wtf that is
>> without looking it up. The rest of the names are fairly self
>> explanatory.  offset? offset_size? misalignment? Not very good with
>> names, but perhaps we can find something more appropriate :-)

Yeah, it's a tricky thing to convey.  And despite all the other
convergence otherwise happening in the standards, T10 and T13 do not
agree how to describe the logical/physical alignment.


Mike> I agree that 'alignment' is too terse/confusing given that it is
Mike> an offset we're exposing.  How about 'alignment_offset'?

I thought I had already changed it to alignment_offset like we talked
about a while ago.  But I guess that change was only done mentally :)

Jens, are you ok with that name?

-- 
Martin K. Petersen	Oracle Linux Engineering
