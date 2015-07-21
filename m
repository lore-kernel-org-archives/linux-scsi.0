From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] target: remove unused lun_flags field from se_lun
Date: Tue, 21 Jul 2015 06:40:42 -0700
Message-ID: <20150721134042.GA30664@infradead.org>
References: <1437434990-13452-1-git-send-email-Spencer.baugh@purestorage.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33428 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbbGUNks (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2015 09:40:48 -0400
Content-Disposition: inline
In-Reply-To: <1437434990-13452-1-git-send-email-Spencer.baugh@purestorage.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Spencer Baugh <spencer.baugh@purestorage.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Spencer Baugh <sbaugh@catern.com>, Chris Zankel <czankel@purestorage.com>

Looks good,

but what's up with your From lines:

On Mon, Jul 20, 2015 at 04:29:49PM -0700, Spencer Baugh wrote:
> From: Spencer Baugh <sbaugh@catern.com>
> 
> From: Chris Zankel <czankel@purestorage.com>

plus another address for you in the actual email From line.  Who
did actually write this patch?
