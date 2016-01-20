From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Separate target visibility from reaped state information
Date: Tue, 19 Jan 2016 19:30:23 -0500
Message-ID: <yq1oachqehs.fsf@sermon.lab.mkp.net>
References: <568FE922.9090004@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36795 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932533AbcATAar (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jan 2016 19:30:47 -0500
In-Reply-To: <568FE922.9090004@sandisk.com> (Bart Van Assche's message of
	"Fri, 8 Jan 2016 17:51:46 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Dan Williams <dan.j.williams@intel.com>, Sebastian Herbszt <herbszt@gmx.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

>>>>> "Bart" == Bart Van Assche <bart.vanassche@sandisk.com> writes:

Bart> Instead of representing the states "visible in sysfs" and "has
Bart> been removed from the target list" by a single state variable, use
Bart> two variables to represent this information.

James: Are you happy with the latest iteration of this? Should I queue
it?

-- 
Martin K. Petersen	Oracle Linux Engineering
