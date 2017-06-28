From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH RESEND] scsi: sun_esp: fix device reference leaks
Date: Tue, 27 Jun 2017 21:47:27 -0400
Message-ID: <yq1tw30yjbk.fsf@oracle.com>
References: <20170621093509.GL6366@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18442 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753016AbdF1Brh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jun 2017 21:47:37 -0400
In-Reply-To: <20170621093509.GL6366@localhost> (Johan Hovold's message of
        "Wed, 21 Jun 2017 11:35:09 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johan Hovold <johan@kernel.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>


Johan,

> Make sure to drop the reference to the dma device taken by
> of_find_device_by_node() on probe errors and on driver unbind.

Looks good to me.

Applied to 4.13/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
