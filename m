From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH take 2] [USB] Use normalized sense when emulating
 autosense
Date: Thu, 11 Nov 2010 05:44:50 -0800
Message-ID: <20101111134450.GB12291@kroah.com>
References: <985163.58416.qm@web31807.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <985163.58416.qm@web31807.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 22, 2010 at 02:12:51PM -0700, Luben Tuikov wrote:
> This patch solves two things:
> 1) Enables autosense emulation code to correctly
> interpret descriptor format sense data, and
> 2) Fixes a bug whereby the autosense emulation
> code would overwrite descriptor format sense data
> with SENSE KEY HARDWARE ERROR in fixed format, to
> incorrectly look like this:
> 
> Oct 21 14:11:07 localhost kernel: sd 7:0:0:0: [sdc]  Sense Key : Recovered Error [current] [descriptor]
> Oct 21 14:11:07 localhost kernel: Descriptor sense data with sense descriptors (in hex):
> Oct 21 14:11:07 localhost kernel:        72 01 04 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
> Oct 21 14:11:07 localhost kernel:        00 4f 00 c2 00 50
> Oct 21 14:11:07 localhost kernel: sd 7:0:0:0: [sdc]  ASC=0x4 ASCQ=0x1d
> 
> Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>

I need to get the ack from the usb-storage maintainer.  Can you get that
so that I can apply this?

thanks,

greg k-h
