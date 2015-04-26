From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 19/23] advansys: Remove cmd_per_lun setting
Date: Sun, 26 Apr 2015 18:55:41 +0200
Message-ID: <20150426165541.GA14192@lst.de>
References: <1429874322-85488-1-git-send-email-hare@suse.de> <1429874322-85488-21-git-send-email-hare@suse.de> <201504261657.01552.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:32781 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbbDZQzn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Apr 2015 12:55:43 -0400
Content-Disposition: inline
In-Reply-To: <201504261657.01552.linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org

On Sun, Apr 26, 2015 at 04:57:01PM +0200, Ondrej Zary wrote:
> This patch breaks my setup: "modprobe advansys" hangs.
> 
> It works when all other patches are applied except this one.

Oh damn, looks like the code does have issues in this case.
So let's just drop this change for now.


Jusr curious: do you have more than a single disk on this controller?

> 
> -- 
> Ondrej Zary
---end quoted text---
