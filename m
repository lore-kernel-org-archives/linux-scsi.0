From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] block: Ensure physical block size is unsigned int
Date: Fri, 08 Oct 2010 01:15:57 -0400
Message-ID: <yq1hbgxs1rm.fsf@sermon.lab.mkp.net>
References: <1285605664-27027-1-git-send-email-martin.petersen@oracle.com>
	<1285605664-27027-2-git-send-email-martin.petersen@oracle.com>
	<20100927174052.GA14180@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:28158 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab0JHFSM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2010 01:18:12 -0400
In-Reply-To: <20100927174052.GA14180@redhat.com> (Mike Snitzer's message of
	"Mon, 27 Sep 2010 13:40:52 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jaxboe@fusionio.com, James.Bottomley@hansenpartnership.com
Cc: Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

>> Physical block size was declared unsigned int to accomodate the
>> maximum size reported by READ CAPACITY(16).  Make sure we use the
>> right type in the related functions.
>> 
>> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

Mike> Acked-by: Mike Snitzer <snitzer@redhat.com>

Jens, ping on the block fix.

James, ping on the sd ditto.

-- 
Martin K. Petersen	Oracle Linux Engineering
