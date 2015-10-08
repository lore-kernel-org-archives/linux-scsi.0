From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: Re: [PATCH 00/18] mpt2sas, mpt3sas: Combine mpt2sas and mpt3sas
 driver code base
Date: Thu, 8 Oct 2015 19:30:16 +0530
Message-ID: <CAK=zhgp_uuwSN_OBJtmoWWcuneNuRJgpEFM2es1EKD9z5jUZAA@mail.gmail.com>
References: <1443628038-13552-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<20151006094629.GA3863@infradead.org>
	<CAK=zhgr=PU_CPdTRp335aRWtPxGnRJDNrnFrK5g+Gz6L8SnhCA@mail.gmail.com>
	<1444151601.2245.16.camel@HansenPartnership.com>
	<CAK=zhgriUAe8STRYGHXBvHeoKFSfk=pFh4gR-PE3TLNOLdh5HQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK=zhgriUAe8STRYGHXBvHeoKFSfk=pFh4gR-PE3TLNOLdh5HQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, "jejb@kernel.org" <jejb@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sathya Prakash <Sathya.Prakash@avagotech.com>, Chaitra Basappa <chaitra.basappa@avagotech.com>, Suganath Prabu Subramani <suganath-prabu.subramani@avagotech.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 7, 2015 at 2:48 PM, Sreekanth Reddy
<sreekanth.reddy@avagotech.com> wrote:
> On Tue, Oct 6, 2015 at 10:43 PM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
>> On Tue, 2015-10-06 at 15:59 +0530, Sreekanth Reddy wrote:
>>> On Tue, Oct 6, 2015 at 3:16 PM, Christoph Hellwig <hch@infradead.org> wrote:
>>> > This series seems to miss patch 5 which actually removes the mpt2sas
>>> > driver - it probably was too large for the list.
>>>
>>> [Sreekanth]
>>>
>>> Yes Chris, As this Phase5 size is 680K, so I think it failed to get
>>> into linux-scsi mail list. In this patch we are just removing the
>>> mpt2sas driver files. Please let me known if need to re-post this
>>> patch divided into 2 to 3 parts.
>>
>> If it's just git rm drivers/scsi/mpt2sas/*, just post that as the
>> command and I can remember to do it as part of the patch series.
>
> [Sreekanth]
>
> Yes James, this is just a 'git rm' command as shown below
>
> # git rm drivers/scsi/mpt2sas/mpt2sas_base.*
> drivers/scsi/mpt2sas/mpt2sas_config.c
> drivers/scsi/mpt2sas/mpt2sas_ctl.*
> drivers/scsi/mpt2sas/mpt2sas_scsih.c
> drivers/scsi/mpt2sas/mpt2sas_transport.c
> drivers/scsi/mpt2sas/mpt2sas_debug.h

James,

   Is it fine to send above command as a patch. i.e subject line will
be same as patch 5 but the contents will be just this 'git rm'
command.

Regards,
Sreekanth
