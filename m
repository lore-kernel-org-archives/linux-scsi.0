From: Sathya Prakash <sathya.prakash@avagotech.com>
Subject: RE: [PATCH 00/20] mpt3sas: driver update
Date: Fri, 24 Apr 2015 15:27:57 -0600
Message-ID: <7bdc4e1dfaee4483c6c4bce12aa2331e@mail.gmail.com>
References: <1427723723-12676-1-git-send-email-Sreekanth.Reddy@avagotech.com>
 <20150405160905.GA15216@infradead.org> <CAK=zhgqRR5f-QJLT18xLWOnBXVeoE2if5rEbskXyDN3H7LSWjg@mail.gmail.com>
 <20150421121337.GA11004@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:36541 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966933AbbDXV17 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Apr 2015 17:27:59 -0400
Received: by wizk4 with SMTP id k4so36321833wiz.1
        for <linux-scsi@vger.kernel.org>; Fri, 24 Apr 2015 14:27:58 -0700 (PDT)
In-Reply-To: <20150421121337.GA11004@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Kashyap Desai <kashyap.desai@avagotech.com>, linux-kernel@vger.kernel.org, Tomas Henzl <thenzl@redhat.com>

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
