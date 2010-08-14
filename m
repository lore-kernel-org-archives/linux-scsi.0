From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: TCM/LIO slides for Linux Storage Filesystem workshop 2010
Date: Fri, 13 Aug 2010 17:52:44 -0700
Message-ID: <1281747164.4930.137.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:44374 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756512Ab0HNA4W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Aug 2010 20:56:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Richard Sharpe <realrichardsharpe@gmail.com>, Joel Becker <joel.becker@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, "Love, Robert W" <robert.w.love@intel.com>, Jerome Martin <jxm@risingtidesystems.com>

Greetings folks,

Here are the slides from the Target Mode / ConfigFS and demo slot this
week:

http://linux-iscsi.org/builds/LIO-LSF-2010/

First, I wanted to say thank you to everyone who was in attendence and
all of the very positive and thoughtful feedback from many different
folks throughout the week.  A consensus was reached during the I/O track
to apply another round of review for TCM/LIO v4.0 on linux-scsi for:

	*) TCM Core HBA/DEV abstraction and subsystem plugins
	*) TCM Core fabric independent configfs infrastructure
	*) TCM_Loop multi-fabric virtual SCSI LLD
	*) LIO-Target iSCSI module

and tag these bits for v2.6.37.  The reason here is two-fold:

	*) Get more eyes on the existing code and shake
           out existing bugs
	*) Allow for addition of new experimental features for 
           in seperate mainline tracking branches for v2.6.38.

The Linux/iSCSI team will be moving forward over the upcoming weeks to
make this second review happen on linux-scsi together with hch, tomo and
mnc.

Also, I am very happy to mention that this was the very first public
demo of the GPL rtsadmin shell to the I/O track community.  I wanted to
give an extra special thanks to the handful of community members who's
own context was allowed to be saved throughout the course of the demo.  
The demo would certainly not have been possible without the presence of
giants from all three LSF tracks!

Best,

--nab


