From: Daniel Gryniewicz <dang@linuxbox.com>
Subject: Re: scsi: add support for a blk-mq based I/O path.
Date: Tue, 16 Sep 2014 13:17:55 -0400
Message-ID: <541870C3.9020607@linuxbox.com>
References: <54184C09.70800@linuxbox.com> <20140916161914.GA2756@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aa.linuxbox.com ([69.128.83.226]:3511 "EHLO aa.linuxbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088AbaIPRR7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Sep 2014 13:17:59 -0400
In-Reply-To: <20140916161914.GA2756@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

On 09/16/2014 12:19 PM, Christoph Hellwig wrote:
> Hi Daniel,
>
> this should also be fixed with my patch "scsi: clean up S/G table freeing",
> can you test if that fixes the issue for you as well?
>


Yeah, that fixes it, thanks.

Daniel
