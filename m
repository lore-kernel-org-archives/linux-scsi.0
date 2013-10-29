From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] [SCSI] aacraid: prevent ZERO_SIZE_PTR dereference
Date: Tue, 29 Oct 2013 23:06:49 +0300
Message-ID: <20131029200649.GE20521@mwanda>
References: <20131025144452.GA28451@ngolde.de>
 <20131029191007.GD21820@longonot.mountain>
 <CA+55aFzTJpx+J3hH+FjsxCmajTjD_nLzHSzbvX02JwDQ1e2U4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18672 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab3J2UHW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Oct 2013 16:07:22 -0400
Content-Disposition: inline
In-Reply-To: <CA+55aFzTJpx+J3hH+FjsxCmajTjD_nLzHSzbvX02JwDQ1e2U4g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, "security@kernel.org" <security@kernel.org>

You and James are right.  It should be checking against the sizeof().
I will send a v2 tomorrow.  Sorry about that.

regards,
dan carpenter
