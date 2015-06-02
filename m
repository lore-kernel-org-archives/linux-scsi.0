From: Sathya Prakash <sathya.prakash@avagotech.com>
Subject: Merging mpt2sas/mpt3sas code base
Date: Tue, 2 Jun 2015 15:40:15 -0600
Message-ID: <011bc20cffa52ae1a7aca1f74c0244d1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:36856 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbbFBVkT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jun 2015 17:40:19 -0400
Received: by wgbgq6 with SMTP id gq6so151169682wgb.3
        for <linux-scsi@vger.kernel.org>; Tue, 02 Jun 2015 14:40:18 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, jejb@kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org
Cc: Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>

Christoh et al,
We have revisited our decision of not merging mpt2sas and mpt3sas driver
after my e-mail below and we concluded that it will be good if we merge
the code of both the drivers for long term maintenance and  future product
inclusions.
However we have decided to  generate two separate binaries mpt2sas.ko and
mpt3sas.ko with retaining existing ioctl interfaces, this is to maintain
same application interfaces as on today and keep downward  compatibility.
We have started this work and planning to conclude this  activity in three
to four months and will submit the patches as soon as they are available
for early upstream review.
Requesting you all to ACK and unblock the current patches on our SAS3
drivers,  so that we can take the latest code as baseline for our patches
for  the merge. Please let us know if you have any specific questions.
Thanks
Sathya

-----Original Message-----
From: Sathya Prakash [mailto:sathya.prakash@avagotech.com]
Sent: Friday, April 24, 2015 3:28 PM
To: 'Christoph Hellwig'; Sreekanth Reddy
Cc: 'jejb@kernel.org'; 'Martin K. Petersen'; 'linux-scsi@vger.kernel.org';
'James E.J. Bottomley'; Kashyap Desai; 'linux-kernel@vger.kernel.org';
'Tomas Henzl'
Subject: RE: [PATCH 00/20] mpt3sas: driver update

Christoph,
We had internal discussion with our engineering and management on this
topic.  We are committed to provide bug fixes ( Only bug fixes and no new
features) across both the SAS2 and SAS3 source trees.  We prefer the SAS2
and SAS3 drivers to stay separate and the reason is;  merging of the
drivers is a time consuming and error prone task and with SAS2 products at
the maintenance mode we are thinking it will be risky to do the merge for
now.

Going forward for our future products we will be providing a  merged
driver (with common source separated out and having multiple kernel
modules compiled out of single source directory for each of our products)
to avoid maintenance overhead.

So please let us know whether the current patches can be ACKED if we
provide the applicable bug fixes to SAS2 or you see any other issues?.

Thanks
Sathya

-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org]
Sent: Tuesday, April 21, 2015 6:14 AM
To: Sreekanth Reddy
Cc: Christoph Hellwig; jejb@kernel.org; Martin K. Petersen;
linux-scsi@vger.kernel.org; James E.J. Bottomley; Sathya Prakash; Kashyap
Desai; linux-kernel@vger.kernel.org; Tomas Henzl
Subject: Re: [PATCH 00/20] mpt3sas: driver update

On Wed, Apr 08, 2015 at 11:13:04AM +0530, Sreekanth Reddy wrote:
> Hi Chris,
>
> There are no corresponding mpt2sas driver's patches, The last phase
> for mpt2sas drivers is Phase20 and this phase driver is already exits
> in the upstream kernel. Also mpt2sas driver is completely in maintains
> mode and there won't be any new features.

But we'll still need all the bugfixes for existing users.

So a big NAK from me for any mpt3 patches that aren't urgen bug fixes
before we finally got the two drivers merged.
