From: Dan Carpenter <error27@gmail.com>
Subject: Re: [patch] target: use after free in error handling
Date: Sun, 14 Aug 2011 22:10:20 +0300
Message-ID: <20110814191020.GB10560@shale.localdomain>
References: <20110809123006.GJ7659@shale.localdomain>
 <1313300165.16439.45.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:51420 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653Ab1HNTMf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Aug 2011 15:12:35 -0400
Content-Disposition: inline
In-Reply-To: <1313300165.16439.45.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Andy Grover <agrover@redhat.com>, Roland Dreier <roland@kernel.org>, Christoph Hellwig <hch@lst.de>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, kernel-janitors@vger.kernel.org

Ah yes...  I should have caught the missing goto out.  I hardly feel
like I deserve the Author tag for this one but I'm always happy to
take credit for other people's hard work.  Moving up the corporate
ladder and all that.

regards,
dan carpenter
