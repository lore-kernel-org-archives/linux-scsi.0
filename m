From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/2] Fix a scsi_host_dev_release() memory leak
Date: Wed, 25 Nov 2015 22:40:44 -0500
Message-ID: <yq137vtjumb.fsf@sermon.lab.mkp.net>
References: <564F910E.9070306@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37075 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbbKZDlU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Nov 2015 22:41:20 -0500
In-Reply-To: <564F910E.9070306@sandisk.com> (Bart Van Assche's message of
	"Fri, 20 Nov 2015 13:30:54 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

>>>>> "Bart" == Bart Van Assche <bart.vanassche@sandisk.com> writes:

Bart> This patch series consists of two patches: - A first patch that
Bart> converts the code that accesses shost->shost_gendev to manipulate
Bart> the shost reference count into scsi_host_{get,put}() calls.  - A
Bart> second patch that fixes the actual memory leak.

I gave a bunch of reviews for v1 but no takers for v2 of the second
patch.

-- 
Martin K. Petersen	Oracle Linux Engineering
