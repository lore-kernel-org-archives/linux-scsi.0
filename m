From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv2 09/14] libata: fixup ZAC device disabling
Date: Wed, 13 Apr 2016 14:09:47 -0400
Message-ID: <20160413180947.GF3676@htj.duckdns.org>
References: <1460443678-57934-1-git-send-email-hare@suse.de>
 <1460443678-57934-10-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:35456 "EHLO
	mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905AbcDMSJu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Apr 2016 14:09:50 -0400
Content-Disposition: inline
In-Reply-To: <1460443678-57934-10-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Tue, Apr 12, 2016 at 08:47:53AM +0200, Hannes Reinecke wrote:
> libata device disabling is ... curious. So add the correct
> definitions that we can disable ZAC devices properly.

Fold into an earlier patch?

Thanks.

-- 
tejun
