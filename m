From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] fix host max depth checking for the 'queue_depth' sysfs interface
Date: Tue, 14 Jul 2015 10:20:14 -0400
Message-ID: <yq1mvyystwh.fsf@sermon.lab.mkp.net>
References: <20150713142439.GA14427@kernel.dk>
	<20150714071358.GA31117@infradead.org> <55A4F0FD.6070305@suse.de>
	<55A516E3.8040708@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30301 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbbGNOVA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2015 10:21:00 -0400
In-Reply-To: <55A516E3.8040708@fb.com> (Jens Axboe's message of "Tue, 14 Jul
	2015 08:04:19 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

>>>>> "Jens" == Jens Axboe <axboe@fb.com> writes:

>> Fully agreed. I would vote for making the host template read-only and
>> modify all drivers to use the shost setting.

Jens> Indeed, that would be a much saner choice. The settings in a
Jens> (effectively already) read-only host template seems like somewhat
Jens> of a relic.

Agree 100%.

-- 
Martin K. Petersen	Oracle Linux Engineering
