From: "Seymour, Shane M" <shane.seymour@hpe.com>
Subject: RE: [PATCH] scsi: rescan VPD attributes
Date: Thu, 26 Nov 2015 09:50:33 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB444E0529@G4W3219.americas.hpqcorp.net>
References: <1447071868-8509-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:59146 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbbKZKB2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Nov 2015 05:01:28 -0500
In-Reply-To: <1447071868-8509-1-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.Petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@odin.com>, Johannes Thumshirn <jthumshirn@suse.com>


> The VPD page information might change, so we need to be able to
> update it. This patch implements a VPD page rescan whenever
> the 'rescan' sysfs attribute is triggered.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---

Reviewed-by: Shane Seymour <shane.seymour@hpe.com>
