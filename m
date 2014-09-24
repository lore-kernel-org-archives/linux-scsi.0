From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3] mptfusion: enable no_write_same for vmware scsi disks
Date: Wed, 24 Sep 2014 01:18:37 -0700
Message-ID: <20140924081837.GB14285@infradead.org>
References: <20140923071154.GB3867@infradead.org>
 <1411482160-32007-1-git-send-email-chris.j.arges@canonical.com>
 <5421F020.1030309@canonical.com>
 <yq14mvxudbv.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq14mvxudbv.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Chris J Arges <chris.j.arges@canonical.com>, hch@infradead.org, bruce.lucas@mongodb.com, adam.radford@avagotech.com, kashyap.desai@avagotech.com, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 23, 2014 at 07:28:04PM -0400, Martin K. Petersen wrote:
> >>>>> "Chris" == Chris J Arges <chris.j.arges@canonical.com> writes:
> 
> Chris> 1) Does this workaround make sense? Perhaps there is an easier
> Chris>    way?
> 
> One option is to ship a udev rule that disables write same on VMware
> disks. However, I don't have a fundamental problem having a workaround
> for this in the kernel.

This sounds way to scary to me.

I'd like to add Chris latests patch and Cc it to stable.

Martin, given that you're ok with it can you give me a review?
