From: Andrew Ryan <genanr@emsphone.com>
Subject: Re: 2.6.0-test1 and qlogic 8.00.00b4 driver
Date: Tue, 29 Jul 2003 11:36:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030729163620.GA18645@thumper2.emsphone.com>
References: <20030728220836.GA10845@thumper2.emsphone.com> <20030729110235.A26675@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from thumper2.emsphone.com ([199.67.51.102]:61399 "EHLO
	thumper2.emsphone.com") by vger.kernel.org with ESMTP
	id S271850AbTG2Qgh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jul 2003 12:36:37 -0400
Content-Disposition: inline
In-Reply-To: <20030729110235.A26675@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, ravi.anand@qlogic.com
Cc: linux-scsi@vger.kernel.org

Ravi wrote
> Make sure that Probe Multi lun support is enabled in the kernel(Under scsi
> device support) Or you can set the module param
> max_scsi_luns/max_scsi_reports_lun in the modules.conf file and build new
> ram disk image.

It is and has always has been 
CONFIG_SCSI_MULTI_LUN=y

Is there a parameter that I can use when I load the module to give me more
debugging information?

On Tue, Jul 29, 2003 at 11:02:35AM +0100, Christoph Hellwig wrote:
> On Mon, Jul 28, 2003 at 05:08:37PM -0500, Andrew Ryan wrote:
> > Linux is not seeing any devices attached to a CMD CRA-7280 san connected
> > raid unit using kernel 2.6.0-test[12] and qlogic drive 8.00.00b4.
> 
> It should be fine with plain -test1, with newer trees you need to add
> a call to scsi_scan_host just after scsi_add_host.
>
I added scsi_scan_host after scsi_add_host and it did not change the
situation, the driver still does not see any devices.  Either the driver or
the kernel changed since it still works fine in 2.5.69 w/qlogic 8.00.00b3
drivers. 

Andy
