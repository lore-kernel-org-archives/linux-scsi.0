From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] Cleanup the I/O that has timed out and is used to
 issue LUN reset
Date: Tue, 15 Mar 2016 02:53:27 -0700
Message-ID: <20160315095327.GB1957@infradead.org>
References: <1457979262-26571-1-git-send-email-satishkh@cisco.com>
 <1457979262-26571-2-git-send-email-satishkh@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [198.137.202.9] ([198.137.202.9]:54953 "EHLO
	bombadil.infradead.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S965454AbcCOJyQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Mar 2016 05:54:16 -0400
Content-Disposition: inline
In-Reply-To: <1457979262-26571-2-git-send-email-satishkh@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Satish Kharat <satishkh@cisco.com>
Cc: linux-scsi@vger.kernel.org


The right fix is to get rid of fnic_clean_pending_aborts entirely.
It's not the low level drivers business to clean up pending commands.
