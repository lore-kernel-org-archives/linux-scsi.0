From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv2] SCSI: usd ida for host number management
Date: Thu, 28 Jan 2016 21:58:06 -0500
Message-ID: <yq11t91rt1d.fsf@sermon.lab.mkp.net>
References: <1453319280-15417-1-git-send-email-lduncan@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49831 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbcA2C6R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2016 21:58:17 -0500
In-Reply-To: <1453319280-15417-1-git-send-email-lduncan@suse.com> (Lee
	Duncan's message of "Wed, 20 Jan 2016 11:48:00 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, martin.petersen@oracle.com, emilne@redhat.com, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>

>>>>> "Lee" == Lee Duncan <lduncan@suse.com> writes:

Lee> Update the SCSI hosts module to use ida to manage its host_no index
Lee> instead of an ATOMIC integer. This means that the SCSI host number
Lee> will now be reclaimable.

Applied to 4.6/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
