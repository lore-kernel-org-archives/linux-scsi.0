From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 08/20] scsi: use 'bool' as return value for
 scsi_normalize_sense()
Date: Fri, 5 Sep 2014 17:09:40 -0700
Message-ID: <20140906000940.GE29588@infradead.org>
References: <1409738775-80876-1-git-send-email-hare@suse.de>
 <1409738775-80876-9-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:56510 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbaIFAHV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Sep 2014 20:07:21 -0400
Content-Disposition: inline
In-Reply-To: <1409738775-80876-9-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Yoshihiro Yunomae <yoshihiro.yunomae.ez@hitachi.com>, linux-scsi@vger.kernel.org

On Wed, Sep 03, 2014 at 12:06:03PM +0200, Hannes Reinecke wrote:
> Convert scsi_normalize_sense() and frieds to return 'bool'
> instead of an integer.

Looks good with the small fix spotted by Yunomae-san.

Signed-off-by: Christoph Hellwig <hch@lst.de>
