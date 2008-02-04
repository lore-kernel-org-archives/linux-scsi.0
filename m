From: David Dillow <dillowda@ornl.gov>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Mon, 04 Feb 2008 12:00:01 -0500
Message-ID: <1202144401.11599.2.camel@lap75545.ornl.gov>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
 <1201639331.3069.58.camel@localhost.localdomain> <47A05CBD.5050803@vlnb.net>
 <47A7049A.9000105@vlnb.net>
 <e2e108260802040553j2f3bf8c2n9fae132e000990f7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emroute3.ornl.gov ([160.91.4.110]:57180 "EHLO emroute3.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753970AbYBDRAF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Feb 2008 12:00:05 -0500
In-reply-to: <e2e108260802040553j2f3bf8c2n9fae132e000990f7@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>


On Mon, 2008-02-04 at 14:53 +0100, Bart Van Assche wrote:
> Another issue I have to look further into is that dd and xdd report
> different results for very large block sizes (> 1 MB).

Be aware that xdd reports 1 MB as 1000000, not 1048576. Though, it looks
like dd is the same, so that's probably not helpful. Also, make sure
you're passing {i,o}flag=direct to dd if you're using -dio in xdd to be
sure you are comparing apples to apples.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


