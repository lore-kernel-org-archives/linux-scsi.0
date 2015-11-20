From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 0/2] Fix a scsi_host_dev_release() memory leak
Date: Fri, 20 Nov 2015 13:30:54 -0800
Message-ID: <564F910E.9070306@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0071.outbound.protection.outlook.com ([207.46.100.71]:8112
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758669AbbKTVa6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Nov 2015 16:30:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

This patch series consists of two patches:
- A first patch that converts the code that accesses shost->shost_gendev 
to manipulate the shost reference count into scsi_host_{get,put}() calls.
- A second patch that fixes the actual memory leak.
