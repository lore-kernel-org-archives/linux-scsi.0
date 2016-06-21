From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] lpfc: support for CPU phys_id and core_id on
 PowerPC64
Date: Tue, 21 Jun 2016 07:29:02 -0700
Message-ID: <20160621142902.GA10597@infradead.org>
References: <1464813809-22066-1-git-send-email-mauricfo@linux.vnet.ibm.com>
 <201606012043.u51KflcX004680@mx0a-001b2d01.pphosted.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42902 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbcFUO3C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jun 2016 10:29:02 -0400
Content-Disposition: inline
In-Reply-To: <201606012043.u51KflcX004680@mx0a-001b2d01.pphosted.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, dick.kennedy@broadcom.com, james.smart@broadcom.com

I really don't think this sort of low level information has business
in a low level driver.  I've been trying to put some infrastructure
together to move this to the core kernel [1], and it would be good to
help use this in more drivers.  Especially given that lpfc may use
blk-mq which will not respect this current assignment for the queue
mapping.

[1] http://lists.infradead.org/pipermail/linux-nvme/2016-June/005012.html
