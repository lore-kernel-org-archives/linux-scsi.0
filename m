From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/2] RESEND: Enable iBFT IPv6 booting with prefix length
Date: Mon, 01 Feb 2016 20:17:30 -0500
Message-ID: <yq11t8vq5at.fsf@sermon.lab.mkp.net>
References: <cover.1453419653.git.lduncan@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46944 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbcBBBRk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Feb 2016 20:17:40 -0500
In-Reply-To: <cover.1453419653.git.lduncan@suse.com> (Lee Duncan's message of
	"Fri, 22 Jan 2016 11:49:11 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, hare@suse.de, Lee Duncan <lduncan@suse.com>

>>>>> "Lee" == Lee Duncan <lduncan@suse.com> writes:

Lee> [Resending. Apologies if you get this twice.]  It turns out that
Lee> IPv6 doesn't care about netmask, but instead uses "prefix length"
Lee> to determine the subnet, but the iBFT subsystem still just supports
Lee> netmask.

Mike, care to review?

	https://patchwork.kernel.org/patch/8092511/
	https://patchwork.kernel.org/patch/8092501/

-- 
Martin K. Petersen	Oracle Linux Engineering
