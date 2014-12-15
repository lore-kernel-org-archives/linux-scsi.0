From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V5 1/3] scsi: Avoid unnecessary GFP_ATOMIC allocation in
 scsi_report_lun_scan
Date: Mon, 15 Dec 2014 07:43:50 -0800
Message-ID: <20141215154350.GA29357@infradead.org>
References: <1417808263-5632-1-git-send-email-revers@redhat.com>
 <1417808263-5632-2-git-send-email-revers@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39880 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbaLOPnu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Dec 2014 10:43:50 -0500
Content-Disposition: inline
In-Reply-To: <1417808263-5632-2-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Evers <revers@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Dec 05, 2014 at 02:37:41PM -0500, Rob Evers wrote:
> Signed-off-by: Rob Evers <revers@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
