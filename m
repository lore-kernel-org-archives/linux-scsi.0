From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 1/4] aic7xxx/aic79xx: call scsi_set_device()
Date: Sun, 29 May 2005 04:27:37 -0400
Message-ID: <42997CF9.8000609@pobox.com>
References: <20050529074029.GA25962@havoc.gtf.org> <20050529082422.GA19685@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:26598 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S261282AbVE2I1l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 May 2005 04:27:41 -0400
In-Reply-To: <20050529082422.GA19685@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> scsi_add_host connects the host to the device tree.  scsi_set_device
> is obsolete and should go away ASAP.

Ahhh, indeed it does.

It sounds like I should remove scsi_set_device(), and all calls to it.

	Jeff


