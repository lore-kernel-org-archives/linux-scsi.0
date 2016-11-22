From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 2/3] hpsa: fallback to use legacy REPORT PHYS command
Date: Tue, 22 Nov 2016 14:21:10 +0100
Message-ID: <1479820870.25031.32.camel@suse.com>
References: <1479454369-100281-1-git-send-email-hare@suse.de>
         <1479454369-100281-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:35125 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754072AbcKVNVW (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Tue, 22 Nov 2016 08:21:22 -0500
In-Reply-To: <1479454369-100281-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Don Brace <don.brace@microsemi.com>, Martin Wilck <martin.wilck@suse.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Fri, 2016-11-18 at 08:32 +0100, Hannes Reinecke wrote:
> Older SmartArray controller do not support the extended REPORT PHYS
> command, so fallback to use the legacy version here.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>

Tested-by: Martin Wilck <mwilck@suse.com>

> ---
>  drivers/scsi/hpsa.c | 28 ++++++++++++++++++++++++++--
>  1 file changed, 26 insertions(+), 2 deletions(-)

-- 
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)

