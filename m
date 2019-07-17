From: Minwoo Im <minwoo.im.dev@gmail.com>
Subject: Re: [PATCH V2] mpt3sas: support target smid for [abort|query] task
Date: Wed, 17 Jul 2019 21:12:03 +0900
Message-ID: <20190717121203.GE10495@minwoo-desktop>
References: <CGME20190714034415epcms2p25f9787cb71993a30f58524d2f355b543@epcms2p2>
 <20190714034415epcms2p25f9787cb71993a30f58524d2f355b543@epcms2p2>
 <860cc8cf-6419-c649-b2d9-19b82f6ebc99@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <860cc8cf-6419-c649-b2d9-19b82f6ebc99@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
Cc: minwoo.im@samsung.com, "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>, "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Euihyeok Kwon <eh81.kwon@samsung.com>, Sarah Cho <sohyeon.jo@samsung.com>, Sanggwan Lee <sanggwan.lee@samsung.com>, Gyeongmin Nam <gm.nam@samsung.com>, Sungjun Park <sj1228.park@samsung.com>
List-Id: linux-scsi@vger.kernel.org

On 19-07-15 08:13:36, Hannes Reinecke wrote:
> I think this is fundamentally wrong.
> ABORT_TASK is used to abort a single task, which of course has to be
> known beforehand. If you don't know the task, what exactly do you hope
> to achieve here? Aborting random I/O?
> Or, even worse, aborting I/O the driver uses internally and corrupt the
> internal workflow of the driver?
> 
> We should simply disallow any ABORT TASK from userspace if the TaskMID
> is zero. And I would even argue to disabllow ABORT TASK from userspace
> completely, as the smid is never relayed to userland, and as such the
> user cannot know which task should be aborted.
> 
> Cheers,
> 
> Hannes

Sreekanth,

Could you please give some thoughts about what Hannes said?
