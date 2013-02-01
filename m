From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/8] [SCSI] mpt2sas : Fix for issue Missing delay not
 getting set during system bootup
Date: Fri, 1 Feb 2013 08:30:42 +0100
Message-ID: <20130201073042.GD1180@kroah.com>
References: <20130201162240.GA21588@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130201162240.GA21588@lsi.com>
Sender: stable-owner@vger.kernel.org
To: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Cc: jejb@kernel.org, Nagalakshmi.Nandigama@lsi.com, JBottomley@Parallels.com, linux-scsi@vger.kernel.org, sathya.prakash@lsi.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 01, 2013 at 09:52:40PM +0530, Sreekanth Reddy wrote:
> Missing delay is not getting set properly. The reason is it is not defined in the same file from where it is being invoked.
> 
> The fix is to move the missing delay module parameter from mpt2sas_base.c to mpt2sas_scsh.c.
> 
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
> ---  
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
