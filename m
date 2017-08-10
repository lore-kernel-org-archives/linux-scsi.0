From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] lpfc: support nvmet_fc defer_rcv callback
Date: Thu, 10 Aug 2017 11:08:33 +0200
Message-ID: <20170810090833.dwxelipklkvy3c6u@infradead.org>
References: <20170801221240.31723-1-jsmart2021@gmail.com>
 <20170801221240.31723-3-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:58967 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750735AbdHJJIg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Aug 2017 05:08:36 -0400
Content-Disposition: inline
In-Reply-To: <20170801221240.31723-3-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>
Cc: linux-nvme@lists.infradead.org, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org

Applied to nvme-4.13 with the void casts removed, but the strings left
as the surrounding code.
