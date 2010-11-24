From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 7/8] target: mark the transport_complete method optional
Date: Tue, 23 Nov 2010 18:40:11 -0800
Message-ID: <1290566411.30138.176.camel@haakon2.linux-iscsi.org>
References: <20101123223053.574330460@bombadil.infradead.org>
	 <20101123223110.999266276@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:54296 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab0KXCpi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2010 21:45:38 -0500
In-Reply-To: <20101123223110.999266276@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Tue, 2010-11-23 at 17:31 -0500, Christoph Hellwig wrote:
> plain text document attachment (lio-optional-transport_complete)
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 

Committed as 30ff153cad with the following message:

"This patch marks the se_subsystem_api->transport_complete() method
 as optional, as this was and is only necessary for TCM/pSCSI in a
 handful of cases MODE_SENSE and MODE_SELECT for TYPE_TAPE."

Thanks Christoph!

--nab


