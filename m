From: Oliver Neukum <oliver@neukum.org>
Subject: Re: Oops unplugging USB stick
Date: Thu, 13 May 2004 19:05:12 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200405131905.12925.oliver@neukum.org>
References: <200405131803.52676.oliver@neukum.org> <1084466344.2066.24.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.kontent.de ([81.88.34.36]:41897 "EHLO Mail1.KONTENT.De")
	by vger.kernel.org with ESMTP id S264309AbUEMRGF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 May 2004 13:06:05 -0400
In-Reply-To: <1084466344.2066.24.camel@mulgrave>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: usb-storage@lists.one-eyed-alien.net, SCSI Mailing List <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>

Am Donnerstag, 13. Mai 2004 18:39 schrieb James Bottomley:
> On Thu, 2004-05-13 at 11:03, Oliver Neukum wrote:
> > May 13 16:48:20 macbeth kernel: usb 1-1: USB disconnect, address 2
> > May 13 16:48:20 macbeth kernel: sd 1:0:0:0: Illegal state transition offline->cancel
> > May 13 16:48:20 macbeth kernel: Badness in scsi_device_set_state at drivers/scsi/scsi_lib.c:1640
> > May 13 16:48:20 macbeth kernel: Call Trace:
> > May 13 16:48:20 macbeth kernel:  [<c0304bda>] scsi_device_set_state+0xea/0x140
> [...]
> 
> That's not actually an oops, it's just a warning that there's an error
> in the state model....the machine proceeded normally after the messages
> appeared, didn't it?  Actually, this one looks to be a residual of the
> fix to a previous problem.  Does the attached make the message go away?

Your fix is working.

	Regards
		Oliver
