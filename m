From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: mpt2sas and mpt3sas merge (again)
Date: Mon, 14 Jul 2014 17:34:06 -0400
Message-ID: <yq1bnsry69d.fsf@sermon.lab.mkp.net>
References: <20140714083547.GA6315@infradead.org> <53C3A170.1070101@suse.de>
	<1405347425.2395.5.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26006 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756358AbaGNVeo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jul 2014 17:34:44 -0400
In-Reply-To: <1405347425.2395.5.camel@dabdike.int.hansenpartnership.com>
	(James Bottomley's message of "Mon, 14 Jul 2014 07:17:05 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, "Reddy, Sreekanth" <Sreekanth.Reddy@avagotech.com>, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-scsi@vger.kernel.org

>>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:

James> I support the concept, since I think everyone told LSI at the
James> time that splitting the drivers would become a maintenance
James> nightmare.

And it is. I'd like to see these drivers merged as well.

James> One of the big reasons we don't have a lot of leverage with them
James> is that they always seem to slide updates around upstream via the
James> distros (often, it has to be admitted the DKM route), so if Red
James> Hat, SUSE, Oracle and Canonical can agree not to accept LSI
James> updates until the driver is done this way, we'd have a lot more
James> leverage.

Unless it's a trivial bug fix Oracle won't take anything that's not
accepted upstream. We are working with Avago/LSI to streamline their
driver process to be a better fit for both upstream development and
distro kernels.

-- 
Martin K. Petersen	Oracle Linux Engineering
