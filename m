From: Lincoln Dale <ltd@cisco.com>
Subject: Re: [iscsi 2/2] iscsi-probe.c
Date: Wed, 24 Sep 2003 13:43:50 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <5.1.0.14.2.20030924133705.0204eab8@mira-sjcm-3.cisco.com>
References: <20030923152306.GA14522@gtf.org>
 <20030923152306.GA14522@gtf.org> <20030923165301.A18885@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-1-in.cisco.com ([171.71.176.70]:26638 "EHLO
	sj-iport-1.cisco.com") by vger.kernel.org with ESMTP
	id S261413AbTIXDnu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Sep 2003 23:43:50 -0400
In-Reply-To: <20030923165301.A18885@infradead.org>
References: <20030923152306.GA14522@gtf.org>
 <20030923152306.GA14522@gtf.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

Jeff, Christoph:

At 01:53 AM 24/09/2003, Christoph Hellwig wrote:
> > #include <linux/blk.h>
>
>Okay, this is for review only, but only a 2.6 version would have the
>slightest chance of getting merged some day..

FYI, we (linux-iscsi@cisco.com) have created a branch of the iSCSI 
initiator (https://sourceforge.net/projects/linux-iscsi/) that we plan to 
submit for inclusion into 2.6 / 2.7.

lots of these things are already addressed and/or fixed.

the branch targeting 2.6 has lots of the 
legacy/backwards-compatability-with-2.4 stuff removed as well as code that 
should be in userspace removed from the kernel driver.  (that fixed a bunch 
of non-IA32 platform issues too)

if you're interested in more details and/or interested in helping review 
the code, let me know.
the more the merrier.


cheers,

lincoln.

