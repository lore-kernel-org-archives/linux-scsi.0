From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [rob@osinvestor.com: Re: SCSI broken]
Date: Wed, 5 Mar 2003 10:03:46 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030305180346.GB1090@beaverton.ibm.com>
References: <20030305144336.GA13722@osinvestor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030305144336.GA13722@osinvestor.com>
List-Id: linux-scsi@vger.kernel.org
To: Rob Radez <rob@osinvestor.com>
Cc: linux-scsi@vger.kernel.org

Rob,
	Would it possible for you to build with CONFIG_SCSI_LOGGING=y
	and boot with scsi_logging=1. Then send the output to me.  The
	output is quite noisy and if you do not have a serial connected
	the last messages maybe all that is needed. This would help
	narrow down the section in the diff.

Rob Radez [rob@osinvestor.com] wrote:
> [forgot to cc: linux-scsi@]
> 
> Also forgot to mention that 2.5.64 hangs in the same spot as 2.5.63.
> 
> ----- Forwarded message from Rob Radez <rob@osinvestor.com> -----
> 
> From: rob@osinvestor.com (Rob Radez)
> To: David van Hoose <davidvh@cox.net>
> Cc: linux-kernel@vger.kernel.org
> Date: Wed, 5 Mar 2003 00:44:57 -0500
> Subject: Re: SCSI broken
> 
> On Tue, Mar 04, 2003 at 11:42:41PM -0600, David van Hoose wrote:
> > Kernels 2.5.63 and 2.5.64 lock up when displaying the information for my 
> > ZipDrive during SCSI probe. Attached is my .config for 2.5.64.
> 
> I suspect I'm seeing something similar.  On SPARC, I'm getting a hang
> after displaying the information for my SCSI CD-ROM drive.
> 
> scsi0 : Sparc ESP100A-FAST
> Vendor: SEAGATE   Model: ST31200W SUN1.05  Rev: 8724
> Type:   Direct-Access                      ANSI SCSI revision: 02
> Vendor: SEAGATE   Model: ST32155W SUN2.1G  Rev: 8456
> Type:   Direct-Access                      ANSI SCSI revision: 02
> Vendor: TOSHIBA   Model: XM-4101TASUNSLCD  Rev: 1755
> Type:   CD-ROM                             ANSI SCSI revision: 02
> <hang>
> 
> .config available on request.  Worked fine in 2.5.62, hangs in 2.5.63.
> Reverting the scsi changes listed at
> http://osinvestor.com/sparc/patch/2.5.63-revertscsi.diff allows 2.5.63
> to boot.
> 
> Regards,
> Rob Radez
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> ----- End forwarded message -----
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-andmike
--
Michael Anderson
andmike@us.ibm.com

