From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/2] mpt3sas: Reference counting fixes from in-flight
 mpt2sas
Date: Thu, 27 Aug 2015 12:15:41 -0700
Message-ID: <1440702941.24282.2.camel@haakon3.risingtidesystems.com>
References: <1440562184-23945-1-git-send-email-nab@daterainc.com>
	 <20150826235434.GA8843@mail.thefacebook.com>
	 <1440633514.31814.3.camel@haakon3.risingtidesystems.com>
	 <CAK=zhgr6gpyW9-+VYcW4Aiv8-m-qdQ=fTeEAm2=OPUDN0FbOAQ@mail.gmail.com>
	 <1440686414.2196.107.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1440686414.2196.107.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Calvin Owens <calvinowens@fb.com>, "Nicholas A. Bellinger" <nab@daterainc.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, "MPT-FusionLinux.pdl" <MPT-FusionLinux.pdl@avagotech.com>, kernel-team@fb.com
List-Id: linux-scsi@vger.kernel.org

On Thu, 2015-08-27 at 07:40 -0700, James Bottomley wrote:
> On Thu, 2015-08-27 at 10:37 +0530, Sreekanth Reddy wrote:
> > HI Nicholas & Calvin,
> > 
> > Thanks for the patchset. Sure We will review and we do some unit
> > testing on this patch series. Currently my bandwidth is occupied with
> > some internal activity, so by end of next week I will acknowledge this
> > series if all the thing are fine with this patch series.
> 
> Calvin responded to your review feedback and that series has been
> outstanding for a while, so I'm not going to drop it from the misc tree.
> However, I will reorder to make it ready for the second push. You have
> until Friday week to find a problem with it.
> 

James, as mentioned this series is functionally identical to Calvin's
mpt2sas series.

Please consider merging it to scsi.git/for-next, so both series are
together and in-sync.

--nab
