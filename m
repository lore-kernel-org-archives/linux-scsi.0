From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] s390 error: implicit declaration of function sg_dma_len
Date: Fri, 25 May 2007 08:47:38 -0500
Message-ID: <1180100858.3717.3.camel@mulgrave.il.steeleye.com>
References: <20070525082238.GA30876@aepfle.de> <4656A778.2000403@suse.de>
	 <20070525.021303.70218696.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:46918 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753427AbXEYNrl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 May 2007 09:47:41 -0400
In-Reply-To: <20070525.021303.70218696.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: hare@suse.de, olaf@aepfle.de, linux-scsi@vger.kernel.org

On Fri, 2007-05-25 at 02:13 -0700, David Miller wrote:
> From: Hannes Reinecke <hare@suse.de>
> Date: Fri, 25 May 2007 11:08:08 +0200
> 
> > James, please apply. ESP cards simply don't fit in a mainframe :-)
> 
> No James, please don't, I have a patch in my sparc-2.6 queue which
> will fix this already, and in a different way.

OK, I won't ... but we're growing users of this base driver now, like
this one:

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=352e921f0dd42f79652cdb50dd91122d068d7209

Could you share the updates you're planning with linux-scsi, just so we
don't run into problems?

Thanks,

James


