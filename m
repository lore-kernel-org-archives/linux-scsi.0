From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/6] target: Send UA on ALUA target port group change
Date: Fri, 19 Jun 2015 15:13:30 +0200
Message-ID: <20150619131330.GA7923@lst.de>
References: <1434009689-112909-1-git-send-email-hare@suse.de> <1434009689-112909-5-git-send-email-hare@suse.de> <20150619130519.GA7783@lst.de> <5584148E.5050503@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:60764 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914AbbFSNNc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Jun 2015 09:13:32 -0400
Content-Disposition: inline
In-Reply-To: <5584148E.5050503@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Jun 19, 2015 at 03:09:34PM +0200, Hannes Reinecke wrote:
> This harks back to my previous mail:
> Under which circumstances will there be more than one se_dev_entry
> structures in lun_deve_list?
> Isn't there a 1:1 relationship?

No.  See my answer to your previous mail.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
