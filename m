From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Fix a memory leak in scsi_host_dev_release()
Date: Mon, 30 Nov 2015 20:46:24 -0500
Message-ID: <yq11tb7eya7.fsf@sermon.lab.mkp.net>
References: <564D0224.9040001@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20779 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539AbbLABq6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Nov 2015 20:46:58 -0500
In-Reply-To: <564D0224.9040001@sandisk.com> (Bart Van Assche's message of
	"Wed, 18 Nov 2015 14:56:36 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

>>>>> "Bart" == Bart Van Assche <bart.vanassche@sandisk.com> writes:

Bart> Avoid that kmemleak reports the following memory leak if a SCSI
Bart> LLD calls scsi_host_alloc() and scsi_host_put() but neither
Bart> scsi_host_add() nor scsi_host_remove(). The following shell
Bart> command triggers that scenario:

Applied to 4.4/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
