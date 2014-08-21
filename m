From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RESEND][PATCH 8/8][SCSI]mpt3sas: Bump mpt3sas driver version to 04.100.00.00
Date: Thu, 21 Aug 2014 17:10:12 -0400
Message-ID: <yq1k361r1l7.fsf@sermon.lab.mkp.net>
References: <20140625104207.GA13042@avagotech.com>
	<yq1a98av9vi.fsf@sermon.lab.mkp.net>
	<CAK=zhgqGVBsgxheZ1ixvGEeOFJ_7fPhO0d4HAh1f4YD1mWG7Sw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK=zhgqGVBsgxheZ1ixvGEeOFJ_7fPhO0d4HAh1f4YD1mWG7Sw@mail.gmail.com>
	(Sreekanth Reddy's message of "Tue, 12 Aug 2014 15:55:43 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jejb@kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Sathya Prakash <Sathya.Prakash@avagotech.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@avagotech.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

Sreekanth> 1. [RESEND][PATCH 7/8][SCSI]mpt3sas: Added Reply Descriptor
Sreekanth>    Post Queue (RDPQ) Array support

Please make the change suggested by Joe Perches and then repost both
mpt2sas and mpt3sas with the appropriate SoB and RB tags so they are
easy for Christoph to pick up.

The only patch I'd like to dig deeper into before accepting it is the
unblock one.

-- 
Martin K. Petersen	Oracle Linux Engineering
