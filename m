From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [mpt3sas driver 02/10] mpt3sas: Used IEEE SGL instead of MPI SGL
 while framing a SMP Passthrough request message.
Date: Thu, 28 Jan 2016 01:16:09 -0800
Message-ID: <20160128091609.GA26956@infradead.org>
References: <1453963027-19770-1-git-send-email-suganath-prabu.subramani@avagotech.com>
 <1453963027-19770-3-git-send-email-suganath-prabu.subramani@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1453963027-19770-3-git-send-email-suganath-prabu.subramani@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath prabu Subaramani <suganath-prabu.subramani@avagotech.com>
Cc: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, krishnaraddi.mankani@avagotech.com, linux-kernel@vger.kernel.org, chaitra.basappa@avagotech.com, sreekanth.reddy@avagotech.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 28, 2016 at 12:06:59PM +0530, Suganath prabu Subaramani wrote:
> From: Suganath prabu Subramani <suganath-prabu.subramani@avagotech.com>
> 
> As driver was using MPI SGL while framing the SMP Passthrough request
> message due to which firmware unable to post the Reply Data in the host
> memory and timeout is observed for this SMP Passthrough request message
> and so unable to perform phy disable operation.

Does this also do the right thing for MPT2 HBAs?
