From: Ben Myers <bpm@sgi.com>
Subject: [LSF/MM TOPIC][ATTEND] protection information and userspace
Date: Wed, 6 Feb 2013 13:51:22 -0600
Message-ID: <20130206195122.GA30652@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.179.29]:50067 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758298Ab3BFTvY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Feb 2013 14:51:24 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lsf-pc@lists.linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com

Hi,

I'm interested in discussing how to pass protection information to and from
userspace.  Maybe Martin could be enlisted for the discussion.

I read that some work has already been done in this area but have not been able
to locate it.  It looks like the bio-integrity code already makes it possible
to generate the t10-dif crc in the filesystem.  It would be good to be able to
get the guard and application tags back out to backup applications such as
xfsdump.  Enabling other applications to generate their own tags in userspace
is also interesting.

Regards,
	Ben
