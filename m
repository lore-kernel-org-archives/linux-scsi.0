From: Adrian Bunk <bunk@fs.tum.de>
Subject: Re: SCSI sg: Questions regarding jiffies usage
Date: Tue, 13 Jul 2004 01:59:39 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040712235939.GA4701@fs.tum.de>
References: <20040711004153.GZ28324@fs.tum.de> <40F2E7EA.6010907@torque.net> <20040712224629.GY4701@fs.tum.de> <40F31ABA.1060709@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hermes.fachschaften.tu-muenchen.de ([129.187.202.12]:46280 "HELO
	hermes.fachschaften.tu-muenchen.de") by vger.kernel.org with SMTP
	id S264367AbUGLX7o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jul 2004 19:59:44 -0400
Content-Disposition: inline
In-Reply-To: <40F31ABA.1060709@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

On Mon, Jul 12, 2004 at 07:11:54PM -0400, Douglas Gilbert wrote:

> Adrian,

Hi Doug,

> There may be some confusion here. The older struct
> sg_header interface did not have explicit per command timeouts.
> As a poor substitute an ioctl was added to associate
> a timeout (in seconds) to the file descriptor. This way
> subsequent commands issued via that file descriptor
> got the new timeout value. This is the "sfp->timeout"
> value. The snippets above show the "sfp->timeout"
> value being set to a default when a sg device is opened
> and then being changed after a SG_SET_TIMEOUT ioctl call.
> 
> The newer sg_io_hdr interface has per command timeouts
> (in milliseconds). A sg_io_hdr::timeout value overrides
> the "sfp->timeout" value. In the above code the
> sg_io_hdr::timeout value is in "srp->header.timeout".

thanks for the explanations.

> Doug Gilbert

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

