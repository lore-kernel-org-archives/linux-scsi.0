From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] virtio_scsi: don't select CONFIG_BLK_DEV_INTEGRITY
Date: Mon, 27 Apr 2015 19:51:28 -0400
Message-ID: <yq1pp6puo3j.fsf@sermon.lab.mkp.net>
References: <1430139374-28741-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30865 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbbD0Xve (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2015 19:51:34 -0400
In-Reply-To: <1430139374-28741-1-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Mon, 27 Apr 2015 14:56:14 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> T10 PI is just another optional feature, LLDDs should work
Christoph> without the infrastructure.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
