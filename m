From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 01/10] scsi: Rename SERVICE_ACTION_IN to
 SERVICE_ACTION_IN_16
Date: Fri, 14 Nov 2014 16:10:23 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B4029593A7E30@G9W0745.americas.hpqcorp.net>
References: <1415262639-121586-1-git-send-email-hare@suse.de>
 <1415262639-121586-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:47504 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934727AbaKNQM3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Nov 2014 11:12:29 -0500
In-Reply-To: <1415262639-121586-2-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Thursday, 06 November, 2014 2:31 AM
> To: James Bottomley
> Cc: Christoph Hellwig; Ewan Milne; Elliott, Robert (Server Storage);
> linux-scsi@vger.kernel.org; Hannes Reinecke
> Subject: [PATCH 01/10] scsi: Rename SERVICE_ACTION_IN to
> SERVICE_ACTION_IN_16
> 
> SPC-3 defines SERVICE ACTION IN(12) and SERVICE ACTION IN(16).
> So rename SERVICE_ACTION_IN to SERVICE_ACTION_IN_16 to be
> consistent with SPC and to allow for better distinction.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Reviewed-by: Robert Elliott <elliott@hp.com>

