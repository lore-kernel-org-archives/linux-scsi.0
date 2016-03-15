From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] Setting scsi host template to indicate that fnic
 does not support multiqueue
Date: Tue, 15 Mar 2016 02:51:40 -0700
Message-ID: <20160315095140.GA1957@infradead.org>
References: <1457979262-26571-1-git-send-email-satishkh@cisco.com>
 <1457979262-26571-4-git-send-email-satishkh@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [198.137.202.9] ([198.137.202.9]:54537 "EHLO
	bombadil.infradead.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932387AbcCOJw3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Mar 2016 05:52:29 -0400
Content-Disposition: inline
In-Reply-To: <1457979262-26571-4-git-send-email-satishkh@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Satish Kharat <satishkh@cisco.com>
Cc: linux-scsi@vger.kernel.org

Sorry, but this patch is bullshit.  Why doesn't it support using blk-mq?
And why didn't I see a single attempt from you to fix it first?
