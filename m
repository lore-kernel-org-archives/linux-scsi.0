From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Wrong DIF guard tag on ext2 write
Date: Tue, 01 Jun 2010 09:22:42 -0400
Message-ID: <yq1pr0akhul.fsf@sermon.lab.mkp.net>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
	<yq1iq64kv9f.fsf@sermon.lab.mkp.net>
	<1275318102.2823.47.camel@mulgrave.site>
	<4C03D5FD.3000202@panasas.com> <20100531154925.GO9453@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:62802 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995Ab0FANYS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2010 09:24:18 -0400
In-Reply-To: <20100531154925.GO9453@laptop> (Nick Piggin's message of "Tue, 1
	Jun 2010 01:49:25 +1000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nick Piggin <npiggin@suse.de>
Cc: Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>

>>>>> "Nick" == Nick Piggin <npiggin@suse.de> writes:

Nick> More complex and maybe more performant would be to avoid holding
Nick> page lock but wait_on_page_writeback in page-modification (write,
Nick> fault) paths. 

That's what I was doing last I looked at this.  I seem to recall that my
head exploded once I added buffer_heads to the mix.  And then the extfs
folks promised to take a look so I didn't mess more with it.

-- 
Martin K. Petersen	Oracle Linux Engineering
