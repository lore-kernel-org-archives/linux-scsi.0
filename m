From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [LSF/MM TOPIC][ATTEND] protection information and userspace
Date: Thu, 07 Feb 2013 14:20:07 -0500
Message-ID: <yq1fw18rkwo.fsf@sermon.lab.mkp.net>
References: <20130206195122.GA30652@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22170 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758711Ab3BGTUA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Feb 2013 14:20:00 -0500
In-Reply-To: <20130206195122.GA30652@sgi.com> (Ben Myers's message of "Wed, 6
	Feb 2013 13:51:22 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Myers <bpm@sgi.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com

>>>>> "Ben" == Ben Myers <bpm@sgi.com> writes:

Ben> I'm interested in discussing how to pass protection information to
Ben> and from userspace.  Maybe Martin could be enlisted for the
Ben> discussion.

I'll be there, obviously.


Ben> I read that some work has already been done in this area but have
Ben> not been able to locate it.  It looks like the bio-integrity code
Ben> already makes it possible to generate the t10-dif crc in the
Ben> filesystem.  

Yep. Although the block layer will generate the PI when the filesystem
submits the bio. So until we have a userland conduit there hasn't been
much point in the filesystems mucking with the PI explicitly.


Ben> It would be good to be able to get the guard and application tags
Ben> back out to backup applications such as xfsdump.  Enabling other
Ben> applications to generate their own tags in userspace is also
Ben> interesting.

However, the app tag is really only good for disk drives. Most array
vendors use it internally. And going forward we're going to use it for
access control instead of opaque storage. So exposing the application
tag space to userland applications is of very limited use at this point.

-- 
Martin K. Petersen	Oracle Linux Engineering
