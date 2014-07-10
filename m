From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V3] scsi_lib: remove the description string in
 scsi_io_completion()
Date: Thu, 10 Jul 2014 00:45:27 -0700
Message-ID: <20140710074527.GB1631@infradead.org>
References: <1404978113-3693-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59092 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbaGJHp2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jul 2014 03:45:28 -0400
Content-Disposition: inline
In-Reply-To: <1404978113-3693-1-git-send-email-mlombard@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, hch@infradead.org, Elliott@hp.com

Thanks,

this looks very nice to me.  It should also allow for later splitting
the error handling from scsi_io_completion into a separate function away
from the fast path.

