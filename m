From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] libfc: sanity check cpu number extracted from xid
Date: Wed, 13 Jul 2016 21:50:33 -0400
Message-ID: <yq1shvdm1hy.fsf@sermon.lab.mkp.net>
References: <20160630070925.ptbgkeq57txs55gf@c203.arch.suse.de>
	<1467300756-7949-1-git-send-email-cleech@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24346 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbcGNBuq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jul 2016 21:50:46 -0400
In-Reply-To: <1467300756-7949-1-git-send-email-cleech@redhat.com> (Chris
	Leech's message of "Thu, 30 Jun 2016 08:32:36 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Leech <cleech@redhat.com>
Cc: Johannes Thumshirn <jth@kernel.org>, fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org, Vasu Dev <vasu.dev@linux.intel.com>

>>>>> "Chris" == Chris Leech <cleech@redhat.com> writes:

Chris> In the receive path libfc extracts a cpu number from the ox_id in
Chris> the fiber channel header and uses that to do a per_cpu_ptr
Chris> conversion.  If, for some reason, a frame is received with an
Chris> invalid ox_id, per_cpu_ptr will return an invalid pointer and the
Chris> libfc receive path will panic the system trying to use it.

Applied to 4.8/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
