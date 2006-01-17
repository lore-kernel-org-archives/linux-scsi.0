From: Andreas Herrmann <AHERRMAN@de.ibm.com>
Subject: Re: [PATCH] zfcp: transport class adaptations II
Date: Wed, 18 Jan 2006 00:50:05 +0100
Message-ID: <OF4C432345.357E73C7-ON412570F9.0082C3FE-412570F9.0082E7B8@de.ibm.com>
References: <20060113181200.GI20718@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:38070 "EHLO
	mtagate3.de.ibm.com") by vger.kernel.org with ESMTP id S932538AbWAQXuI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jan 2006 18:50:08 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate3.de.ibm.com (8.12.10/8.12.10) with ESMTP id k0HNo7Ws142086
	for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2006 23:50:07 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k0HNo7qp189940
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jan 2006 00:50:07 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id k0HNo7ul012340
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jan 2006 00:50:07 +0100
In-Reply-To: <20060113181200.GI20718@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jejb@steeleye.com>, Linux SCSI <linux-scsi@vger.kernel.org>

On 13.01.2006 19:12 Christoph Hellwig <hch@infradead.org> wrote:
> btw, does zfcp now always have rports as parents for
> targets so we can remove the special case in fc_target_setup?

If you mean the initialisation to "known non-values".  I think this is
not needed by zfcp.

In fact beginning with 2.6.13 or so I was forced to introduce rports
to zfcp because _scsi_add_device did not work otherwise.

I guess you also mean that the get_starget##field stuff can be removed
from fc_starget_show_function?

Or why would we need those get_starget functions if information is
received from rports and the functions are not used somewhere else.

This may affect lpfc and qla2xxx, too.


Regards,

Andreas

