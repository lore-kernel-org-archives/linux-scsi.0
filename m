From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] 2.5.31 scsi_error.c cleanup
Date: Thu, 22 Aug 2002 13:10:48 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020822201048.GD1336@beaverton.ibm.com>
References: <20020822163439.GA1336@beaverton.ibm.com> <200208221711.g7MHBFU03459@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200208221711.g7MHBFU03459@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley [James.Bottomley@SteelEye.com] wrote:
> Ah, OK.  I missed that in the logic flow.  Does it perhaps make sense to move 
> the offline into its own nicely named function?  It might add to the initial 
> readability of scsi_unjam_host.  I see it was problematic because the offline 
> loop is bound up inside the host loop.
> 
> James

On early versions of the patch I had off-lining in its own function, but
moved it into scsi_eh_bus_host_reset for some forgotten reason. I will
re-roll the patch with a offline function as I agree it will improve the
readability of scsi_unjam_host.

-Mike

-- 
Michael Anderson
andmike@us.ibm.com

