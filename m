From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Badness in device_release at drivers/base/core.c:84
Date: Mon, 4 Aug 2003 11:57:25 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030804115725.A26812@beaverton.ibm.com>
References: <20030801182207.GA3759@blazebox.homeip.net> <20030801144455.450d8e52.akpm@osdl.org> <20030803015510.GB4696@blazebox.homeip.net> <20030802190737.3c41d4d8.akpm@osdl.org> <20030803214755.GA1010@blazebox.homeip.net> <20030803145211.29eb5e7c.akpm@osdl.org> <20030803222313.GA1090@blazebox.homeip.net> <20030803223115.GA1132@blazebox.homeip.net> <20030804093035.A24860@beaverton.ibm.com> <1060021614.889.6.camel@blaze.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1060021614.889.6.camel@blaze.homeip.net>; from paulb@blazebox.homeip.net on Mon, Aug 04, 2003 at 02:26:54PM -0400
To: Paul Blazejowski <paulb@blazebox.homeip.net>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "Justin T. Gibbs" <gibbs@scsiguy.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 04, 2003 at 02:26:54PM -0400, Paul Blazejowski wrote:
> 
> Patrick,
> 
> I enabled CONFIG_SCSI_LOGGING=y in kernel then i used
> scsi_mod.scsi_logging_level=0x140 and scsi_mod.max_scsi_luns=1 when
> booting the kernel from lilo.I can see some debug information scroll on
> the screen and i did see ID0 LUN0 get probed even the correct transfer
> rate for the SCSI disk is set.I forgot but isn't there a key sequence
> when pressed it will stop the screen output like pause/break key?
> 
> I have few screen snaps which can be viewed at 
> http://www.blazebox.homeip.net:81/diffie/images/linux-2.6.0-test2/aic7xxx/

Yep, the shot that might have useful information is blurred.

I assume you are unable to use a serial console.

I can usually "Shift + page-up" as long as there is not too much data, and
depending on your console, AFAIR I can't pause my console output.

Also, does the adapter bios show the drive at boot time?

Hopefully Justin will add more useful suggestions for debugging.

-- Patrick Mansfield
