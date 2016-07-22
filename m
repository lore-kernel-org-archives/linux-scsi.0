From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 4/6] block: Add 'zoned' sysfs queue attribute
Date: Fri, 22 Jul 2016 16:45:43 -0400
Message-ID: <yq1wpkd9zbc.fsf@sermon.lab.mkp.net>
References: <1468934439-93579-1-git-send-email-hare@suse.de>
	<1468934439-93579-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38166 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbcGVUpz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jul 2016 16:45:55 -0400
In-Reply-To: <1468934439-93579-5-git-send-email-hare@suse.de> (Hannes
	Reinecke's message of "Tue, 19 Jul 2016 15:20:37 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Damien Le Moal <damien.lemoal@hgst.com>

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> Add a sysfs queue attribute 'zoned' to display the zone layout
Hannes> for zoned devices.

Not quite one value per file :(

-- 
Martin K. Petersen	Oracle Linux Engineering
