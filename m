From: Dave Chinner <david@fromorbit.com>
Subject: Re: Thin provisioning & arrays
Date: Wed, 12 Nov 2008 10:08:52 +1100
Message-ID: <20081111230852.GM2373@disturbed>
References: <28572.1226369378@ocs10w> <49198FC3.7080301@redhat.com> <49199CFF.8080002@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:4771 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751422AbYKKXJ1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Nov 2008 18:09:27 -0500
Content-Disposition: inline
In-Reply-To: <49199CFF.8080002@hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jim owens <jowens@hp.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, Keith Owens <kaos@ocs.com.au>, Black_David@emc.com, dwmw2@infradead.org, martin.petersen@oracle.com, chris.mason@oracle.com, jens.axboe@oracle.com, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, coughlan@redhat.com, matthew@wil.cx

On Tue, Nov 11, 2008 at 09:55:59AM -0500, jim owens wrote:
> Ric Wheeler wrote:
>> Thing is being pitched to answer a very specific customer use case -  
>> shared storage (mid to high end almost exclusively) with several  
>> different users and applications....
...
> It is up to the customer to manage their storage so it never
> reaches the unable-to-write state.

Sure, but putting the entire management burden of obtaining and
running defrag tools in every one of their large set of OS's is the
wrong approach.

We can and should be designing new functionality for the data center
in such a manner that does not require large scale manual
intervention to maintain the systems. Your customers won't thank you
for solving the thin provisioning management problem by requiring
them to do extra hand-holding....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
