From: Damien Le Moal <damien.lemoal@hgst.com>
Subject: Re: [PATCH 1/5] sd: configure ZBC devices
Date: Wed, 20 Jul 2016 09:46:32 +0900
Message-ID: <8000ae17-07f4-3a11-4ca2-bf6acb27ffdb@hgst.com>
References: <1468934710-93876-1-git-send-email-hare@suse.de>
 <1468934710-93876-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:11826 "EHLO
	esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbcGTA4N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2016 20:56:13 -0400
In-Reply-To: <1468934710-93876-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>


On 7/19/16 22:25, Hannes Reinecke wrote:
> For ZBC devices I/O must not cross zone boundaries, so setup
> the 'chunk_sectors' block queue setting to the zone size.
> This is only valid for REPORT ZONES SAME type 2 or 3;
> for other types the zone sizes might be different
> for individual zones. So issue a warning if the type is
> found to be different.
> Also the capacity might be different from the announced
> capacity, so adjust it as needed.
>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/sd.c         | 120 ++++++++++++++++++++++++++++++++++++++++++++--
>  drivers/scsi/sd.h         |  12 +++++
>  include/scsi/scsi_proto.h |  17 +++++++
>  3 files changed, 144 insertions(+), 5 deletions(-)

Reviewed-by: Damien Le Moal <damien.lemoal@hgst.com>
Tested-by: Damien Le Moal <damien.lemoal@hgst.com>

-- 
Damien Le Moal, Ph.D.
Sr. Manager, System Software Group, HGST Research,
HGST, a Western Digital brand
Damien.LeMoal@hgst.com
(+81) 0466-98-3593 (ext. 513593)
1 kirihara-cho, Fujisawa,
Kanagawa, 252-0888 Japan
www.hgst.com
Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:

This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.

