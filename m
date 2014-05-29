From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCHv2 0/5] Support 64-bit LUNs
Date: Thu, 29 May 2014 08:39:14 +0000
Message-ID: <1401352753.27691.6.camel@dabdike>
References: <1400583791-123120-1-git-send-email-hare@suse.de>
	 <20140528105603.GA22379@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:38911 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933139AbaE2IjS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 May 2014 04:39:18 -0400
In-Reply-To: <20140528105603.GA22379@infradead.org>
Content-Language: en-US
Content-ID: <B2559A8A6442FF459AF63063C39346C8@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.de" <hare@suse.de>

On Wed, 2014-05-28 at 03:56 -0700, Christoph Hellwig wrote:
> James, can you take a look at this series?  I would be great to get it
> merged for 3.16!

Remind me how we're planning to fix the conversion bug in
scsilun_to_int, it doesn't seem to be in the patch series anymore... I
remember there were objections, but I think the need to be consistent
overrides most of them, so I think I'm happy with the original proposal.

James

