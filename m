From: Hannes Reinecke <hare@suse.de>
Subject: Re: remove old and unmaintained ISA driver
Date: Tue, 20 Sep 2016 11:53:12 +0200
Message-ID: <a7f3c8a1-d060-1823-c7fa-0277b50887fb@suse.de>
References: <1474300253-31351-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43751 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932662AbcITJxO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Sep 2016 05:53:14 -0400
In-Reply-To: <1474300253-31351-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: schmitzmic@gmail.com, linux@rainbow-software.org, fthain@telegraphics.com.au

On 09/19/2016 05:50 PM, Christoph Hellwig wrote:
> Per discussion in last year and last week there are a few old ISA SCSI
> drivers that haven't seen any work since the dawn of git, and most likely
> no users.  Drop them to speed up killing off the scsi_module.c
> infrastruture.
> 
I'm all for it.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
