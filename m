From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/2] mpt3sas: Reference counting fixes from in-flight
 mpt2sas
Date: Thu, 27 Aug 2015 00:07:39 -0700
Message-ID: <1440659259.9807.24.camel@haakon3.risingtidesystems.com>
References: <1440562184-23945-1-git-send-email-nab@daterainc.com>
	 <20150826235434.GA8843@mail.thefacebook.com>
	 <1440633514.31814.3.camel@haakon3.risingtidesystems.com>
	 <CAK=zhgr6gpyW9-+VYcW4Aiv8-m-qdQ=fTeEAm2=OPUDN0FbOAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK=zhgr6gpyW9-+VYcW4Aiv8-m-qdQ=fTeEAm2=OPUDN0FbOAQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: Calvin Owens <calvinowens@fb.com>, "Nicholas A. Bellinger" <nab@daterainc.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, "MPT-FusionLinux.pdl" <MPT-FusionLinux.pdl@avagotech.com>, kernel-team@fb.com
List-Id: linux-scsi@vger.kernel.org

Hi Sreekanth,

On Thu, 2015-08-27 at 10:37 +0530, Sreekanth Reddy wrote:
> HI Nicholas & Calvin,
> 
> Thanks for the patchset. Sure We will review and we do some unit
> testing on this patch series. Currently my bandwidth is occupied with
> some internal activity, so by end of next week I will acknowledge this
> series if all the thing are fine with this patch series.
> 

Thanks for the quick response.

So Calvin's mpt2sas series has been merged into scsi.git/for-next.

Since this series is AFAICT functionally identical to Calvin's changes,
I assume JEJB will be merging it up for v4.3-rc1 soon too.

Also, we're probably not the only ones hitting this class of OOPsen, so
it will certainly need to be picked up for stable at some point, and any
further regressions will need to be addressed.

Please keep the list posted of your testing progress.

For reference, here are prerequisites need to apply atop v3.14.y:

4dc06fd mpt3sas: delay scsi_add_host call to work with scsi-mq
35b6236 mpt3sas: combine fw_event_work and its event_data
62c4da4 mpt3sas: correct scsi_{target,device} hostdata allocation

--nab
