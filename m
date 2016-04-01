From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 2/2] scsi: vpd pages are mandatory for SPC-2
Date: Fri, 01 Apr 2016 09:45:24 +0200
Message-ID: <832f9d5b74da45871e43175b98daacca@suse.de>
References: <1459493857-4724-1-git-send-email-hare@suse.de>
 <1459493857-4724-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35913 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947AbcDAHp0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2016 03:45:26 -0400
In-Reply-To: <1459493857-4724-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, linux-scsi-owner@vger.kernel.org

On 2016-04-01 08:57, Hannes Reinecke wrote:
> VPD pages 0x0 and 0x83 are mandatory even for SPC-2, so we should
> be lowering the restriction to avoid having to whitelist every
> SPC-2 compliant device.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>

Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
