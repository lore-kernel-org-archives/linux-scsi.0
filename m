From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [dm-devel] QUEUE_FLAG_CLUSTER?
Date: Tue, 30 Nov 2010 13:40:56 -0500
Message-ID: <yq11v627iyv.fsf@sermon.lab.mkp.net>
References: <85ABFDC4641C4847BA6088F2982EFD8F04A4A669@nonamew.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:50873 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab0K3TQO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2010 14:16:14 -0500
In-Reply-To: <85ABFDC4641C4847BA6088F2982EFD8F04A4A669@nonamew.ptu.promise.com> (Ed
	Lin's message of "Mon, 29 Nov 2010 11:08:50 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ed Lin - PTU <ed.lin@promise.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org, Promise_Linux <Promise_Linux@promise.com>, stable@kernel.org

>>>>> "Ed" == "Ed Lin <- PTU" <ed.lin@promise.com>> writes:

Ed> Is it possible to port the patch to previous kernels?

There's a bit of fuzz due to some of the discard changes and the sysfs
export of the segment size. But the core of the patch is the same.

http://git.kernel.org/pub/scm/linux/kernel/git/mkp/linux-2.6-mkp.git
git://git.kernel.org/pub/scm/linux/kernel/git/mkp/linux-2.6-mkp.git

I've created three branches:

for-stable-2.6.32.y
for-stable-2.6.35.y
for-stable-2.6.36.y

-- 
Martin K. Petersen	Oracle Linux Engineering
