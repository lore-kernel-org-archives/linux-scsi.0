From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [dm-devel] [LSF/MM ATTEND] discuss blk-mq related to DM-multipath and status of XCOPY
Date: Tue, 06 Jan 2015 18:55:48 -0500
Message-ID: <yq17fwz8nwb.fsf@sermon.lab.mkp.net>
References: <CAMM=eLdGQ4wQDHy0ACzDsYOs0AYC+KAcx7Mx7FmpBTV293d41Q@mail.gmail.com>
	<54AA90B1.1030201@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51927 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbbAFX4T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2015 18:56:19 -0500
In-Reply-To: <54AA90B1.1030201@suse.de> (Hannes Reinecke's message of "Mon, 05
	Jan 2015 14:25:05 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> Yep. That definitely needs to be discussed.  Especially we'd
Hannes> need to discuss how to handle exceptions, seeing that XCOPY
Hannes> might fail basically at any time.  

Like any SCSI command :)

-- 
Martin K. Petersen	Oracle Linux Engineering
