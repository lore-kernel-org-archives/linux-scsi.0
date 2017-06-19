From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: mptsas crash on expander hot-remove
Date: Mon, 19 Jun 2017 10:23:40 +0200
Message-ID: <20170619082340.GC3752@linux-x5ow.site>
References: <20170616235708.GA19825@hangar16.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45411 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753428AbdFSIXm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Jun 2017 04:23:42 -0400
Content-Disposition: inline
In-Reply-To: <20170616235708.GA19825@hangar16.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Will Simoneau <simoneau@hangar16.net>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, tj@kernel.org

On Fri, Jun 16, 2017 at 07:57:08PM -0400, Will Simoneau wrote:
> Is this is a known / obvious issue, or should I try to bisect it?

This is a known issue with SAS (and FC) drivers, although no soulution exists
to this point.

	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
