From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/25] mpt3sas: Mergering mpt2sas & mpt3sas driver code
Date: Wed, 11 Nov 2015 20:09:57 -0500
Message-ID: <yq1d1vguioq.fsf@sermon.lab.mkp.net>
References: <1447243241-10912-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447243241-10912-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	(Sreekanth Reddy's message of "Wed, 11 Nov 2015 17:30:16 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, chaitra.basappa@avagotech.com, suganath-prabu.subramani@avagotech.com, Hannes Reinecke <hare@suse.de>, christopher.owens@avagotech.com, peter.rivera@avagotech.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

Sreekanth,

Sreekanth> Last time we have posted a set of patches which combine the
Sreekanth> mpt2sas and mpt3sas driver code. and we are generating two
Sreekanth> driver modules (i.e. two separate .ko's) from this Combined
Sreekanth> driver source.

I have merged your combined driver.

The patches in the single-module portion of the series did not compile
individually and I gave up untangling them. They were fundamentally too
intertwined and I squashed them into one commit. Since it's mostly
boilerplate stuff it should not matter too much from a bisection
perspective.

Thanks for doing this work! This will make things much easier going
forward.

-- 
Martin K. Petersen	Oracle Linux Engineering
