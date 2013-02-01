From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 5/8] [SCSI] mpt2sas : Fix for device scan following host
 reset could get stuck in a infinite loop
Date: Fri, 1 Feb 2013 08:30:54 +0100
Message-ID: <20130201073054.GE1180@kroah.com>
References: <20130201162830.GA21652@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130201162830.GA21652@lsi.com>
Sender: stable-owner@vger.kernel.org
To: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Cc: jejb@kernel.org, Nagalakshmi.Nandigama@lsi.com, JBottomley@Parallels.com, linux-scsi@vger.kernel.org, sathya.prakash@lsi.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 01, 2013 at 09:58:30PM +0530, Sreekanth Reddy wrote:
> Modified device scan routine so each configuration page read breaks from the while loop
> when the ioc_status is not equal to MPI2_IOCSTATUS_SUCCESS.
> 
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
> ---
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
