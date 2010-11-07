From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC PATCH] SCSI host lock push-down
Date: Sun, 07 Nov 2010 11:57:03 -0500
Message-ID: <4CD6DA5F.3050905@garzik.org>
References: <20101105002409.GA21714@havoc.gtf.org> <4CD66222.5040808@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4CD66222.5040808@panasas.com>
Sender: linux-ide-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 11/07/2010 03:24 AM, Boaz Harrosh wrote:
> Well now isn't that simple? One nit for me though.
> I would like to see a more scary name for above something like:
> DEF_SCSI_QCMD_WITH_LOCKING or
> DEF_SCSI_QCMD_OLD_WAY

I don't have a real preference; whatever the community prefers.  Maybe I 
would suggest DEF_SCSI_QCMD_LOCKER.


> Something that calls for a cleanup and removal the first time
> the driver is touched.
>
> Otherwise I think this is the only form that should make it safe
> for this Kernel.
>
> (The rename could be nice also though it is one additional hunk in
>   each driver. Did you use a script to produce this?)

No script; a few vim macros helped a bit.  I wanted to actually examine 
each callsite, to get a feel of the locking scheme, and make sure my 
change was truly an equivalent-transformation.

	Jeff



