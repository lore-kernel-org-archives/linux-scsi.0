From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 16/20] scsi: separate out scsi_retval_string()
Date: Sun, 7 Sep 2014 09:11:27 -0700
Message-ID: <20140907161127.GB16238@infradead.org>
References: <1409738775-80876-1-git-send-email-hare@suse.de>
 <1409738775-80876-17-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52160 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbaIGQLa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Sep 2014 12:11:30 -0400
Content-Disposition: inline
In-Reply-To: <1409738775-80876-17-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Yoshihiro Yunomae <yoshihiro.yunomae.ez@hitachi.com>, linux-scsi@vger.kernel.org

On Wed, Sep 03, 2014 at 12:06:11PM +0200, Hannes Reinecke wrote:
> Implement scsi_retval_string() to simplify logging.

Needs a way better patch description.  What exactly is this going to be
useful for?

