From: Liran Schour <LIRANS@il.ibm.com>
Subject: Re: Support for CDB length > 16
Date: Tue, 18 Nov 2003 13:15:31 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFD032B1FF.F1D45476-ONC2256DE2.0039CF43-C2256DE2.003DD890@il.ibm.com>
References: <3FB9E777.6020404@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:48799 "EHLO
	mtagate6.uk.ibm.com") by vger.kernel.org with ESMTP id S262598AbTKRLhg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Nov 2003 06:37:36 -0500
In-Reply-To: <3FB9E777.6020404@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org





Doug Gilbert wrote:

> It is hard to imagine any other way at the moment (definitely
> in lk 2.4 and it is probably a bit late for lk 2.6).

> Is there an upper limit on the size of the cdb you are interested in
> (e.g. XDWRITE EXTENDED in SBC-2 is 64 bytes)?
I have an upperlimit of 256 bytes.

> How were you planning to pass the cdb (length > 16) to the kernel?
I am planning to build a filesystem in the kernel that will be over an OSD
SCSI device. This layer will interact directly with the SCSI system.

Thanks,
- Liran


