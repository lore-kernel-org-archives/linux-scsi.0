From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: [PATCH 0 of 7] Block/SCSI Data Integrity Support
Date: Thu, 17 Jul 2008 09:55:45 -0400
Message-ID: <170fa0d20807170655y6cb7df7eh6aae8c727b7b0bb@mail.gmail.com>
References: <patchbomb.1212814533@sermon.lab.mkp.net>
	 <x491w35bbdi.fsf@segfault.boston.devel.redhat.com>
	 <yq1iqwhia2m.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.238]:42363 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757128AbYGQNzr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jul 2008 09:55:47 -0400
Received: by wx-out-0506.google.com with SMTP id h29so3906376wxd.4
        for <linux-scsi@vger.kernel.org>; Thu, 17 Jul 2008 06:55:46 -0700 (PDT)
In-Reply-To: <yq1iqwhia2m.fsf@sermon.lab.mkp.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ext4@vger.kernel.org

On Tue, Jun 10, 2008 at 11:28 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Jeff" == Jeff Moyer <jmoyer@redhat.com> writes:
>
> Jeff> Thanks for all of the great documentation.  It would be good to
> Jeff> include some instructions on how one would test this, and what
> Jeff> testing you performed.
>
> modprobe scsi_debug dix=199 dif=1 guard=1 dev_size_mb=1024 num_parts=1
>
> I'm testing with XFS and btrfs.  Generally doing kernel builds, etc.
> ext2/3 are still problematic because they modify pages in flight.

Have you made the ext2/3/4 developers aware of this?

Could you elaborate on the interaction between the data integrity
support in the block layer and a given filesystem?  Shouldn't _any_
filesystem "just work" given that the block layer is what is
generating the checksums and then verifying them on read?

regards,
Mike
