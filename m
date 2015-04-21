From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/20] mpt3sas: driver update
Date: Tue, 21 Apr 2015 05:13:37 -0700
Message-ID: <20150421121337.GA11004@infradead.org>
References: <1427723723-12676-1-git-send-email-Sreekanth.Reddy@avagotech.com>
 <20150405160905.GA15216@infradead.org>
 <CAK=zhgqRR5f-QJLT18xLWOnBXVeoE2if5rEbskXyDN3H7LSWjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51988 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbbDUMNj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2015 08:13:39 -0400
Content-Disposition: inline
In-Reply-To: <CAK=zhgqRR5f-QJLT18xLWOnBXVeoE2if5rEbskXyDN3H7LSWjg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: Christoph Hellwig <hch@infradead.org>, "jejb@kernel.org" <jejb@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sathya Prakash <Sathya.Prakash@avagotech.com>, Kashyap Desai <kashyap.desai@avagotech.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Tomas Henzl <thenzl@redhat.com>

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
