From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sd: spurious error messages in READ_CAPACITY(16)
Date: Tue, 30 Mar 2010 13:21:05 -0400
Message-ID: <yq1hbnxenem.fsf@sermon.lab.mkp.net>
References: <20100329072924.1DB8F337C3@ochil.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:58286 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704Ab0C3RVP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2010 13:21:15 -0400
In-Reply-To: <20100329072924.1DB8F337C3@ochil.suse.de> (Hannes Reinecke's
	message of "Mon, 29 Mar 2010 09:29:24 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> sd always tries to submit a READ_CAPACITY(16) CDB, regardless
Hannes> whether the host actually supports it.  queuecommand() will then
Hannes> return DID_ABORT, which is not qualified enough to detect the
Hannes> true cause here.  So better check in sd_try_rc16 first if the
Hannes> cdblen is supported.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
