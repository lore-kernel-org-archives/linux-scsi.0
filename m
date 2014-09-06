From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCHv2 00/20] scsi logging update
Date: Fri, 5 Sep 2014 17:51:29 -0700
Message-ID: <20140906005129.GA6615@infradead.org>
References: <1409738775-80876-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33297 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbaIFAvc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Sep 2014 20:51:32 -0400
Content-Disposition: inline
In-Reply-To: <1409738775-80876-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Yoshihiro Yunomae <yoshihiro.yunomae.ez@hitachi.com>, linux-scsi@vger.kernel.org

One more request:

if you already do major surgery to constan.c can we get rid of the
CONFIG_SCSI_CONSTANTS all over it?

E.g. only keep the code under CONFIG_SCSI_CONSTANTS in, maybe
add a no-constants.c for the stubs and move the bit of glue code
always compiled to scsi.c?
