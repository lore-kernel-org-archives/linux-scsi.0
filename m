From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv2 05/14] libata: NCQ Encapsulation for READ LOG DMA EXT
Date: Thu, 14 Apr 2016 12:07:50 -0400
Message-ID: <20160414160750.GF12583@htj.duckdns.org>
References: <1460443678-57934-1-git-send-email-hare@suse.de>
 <1460443678-57934-6-git-send-email-hare@suse.de>
 <20160413180735.GD3676@htj.duckdns.org>
 <570F2E33.3080709@suse.de>
 <20160414154338.GB12583@htj.duckdns.org>
 <570FBE74.2040202@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f65.google.com ([209.85.192.65]:35461 "EHLO
	mail-qg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbcDNQHx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Apr 2016 12:07:53 -0400
Content-Disposition: inline
In-Reply-To: <570FBE74.2040202@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org

On Thu, Apr 14, 2016 at 05:59:48PM +0200, Hannes Reinecke wrote:
> For this patch, yes, you are right.
> However, the ZAC enablement patches later on submit READ LOG EXT commands
> (for REPORT ZONES), and _they_ benefit from NCQ encapsulation.

Umm... so, you can't use ata_exec_internal() outside of EH context.

-- 
tejun
