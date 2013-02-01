From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 6/8] [SCSI] mpt2sas : When SCSI command is received with
 task atrribute not set, set it to SIMPLE
Date: Fri, 1 Feb 2013 08:31:03 +0100
Message-ID: <20130201073103.GF1180@kroah.com>
References: <20130201163026.GA21679@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130201163026.GA21679@lsi.com>
Sender: stable-owner@vger.kernel.org
To: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Cc: jejb@kernel.org, Nagalakshmi.Nandigama@lsi.com, JBottomley@Parallels.com, linux-scsi@vger.kernel.org, sathya.prakash@lsi.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 01, 2013 at 10:00:26PM +0530, Sreekanth Reddy wrote:
> When SCSI command is received with task attribute not set, set it to SIMPLE.
> Previously it is set to untagged. This causes the firmware to fail the commands.
> 
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
> ---
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
