From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] 4/6: scsi_allow_ghost_devices
Date: Mon, 19 Apr 2004 13:14:10 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040419131410.A10772@infradead.org>
References: <20040418185950.GG4868@tpkurt.garloff.de> <20040418202022.B3393@infradead.org> <1082360042.4691.3.camel@laptop.fenrus.com> <1082376382.4635.65.camel@compaq.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:7950 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S264372AbUDSMOP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Apr 2004 08:14:15 -0400
Content-Disposition: inline
In-Reply-To: <1082376382.4635.65.camel@compaq.xsintricity.com>; from dledford@redhat.com on Mon, Apr 19, 2004 at 08:06:22AM -0400
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Arjan Van de Ven <arjanv@redhat.com>, Kurt Garloff <garloff@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>

On Mon, Apr 19, 2004 at 08:06:22AM -0400, Doug Ledford wrote:
> Actually, the original reason for the patch was the fact that some
> external boxes use LUN 0 as a control device that you send commands to
> in order to init logical volumes.  Without access to the control device
> (which previously was always shown as offline), you couldn't set the box
> up with any linux tools, you would have to set up the logical volumes
> under Windows then boot into linux to see them.  Since the LUN 0 device
> wasn't really offline, but instead was reported as a disk device with no
> attached physical device, this patch was created to allow the linux
> kernel to send commands to the control device.

Man is that a horrible cludge.  Can't one of the EMC folks on this list
kick their firmware group to fix this horrible crap? I.e. make lun a non-disk
device that can be accessed by sg and isn't marked offline?  It can't be
_that_ difficult.  And btw, what tools actually need that access, does some
have pointers to a tarball - I really wonder what they do.

Yeah, Enterprise storage.  I wonder why people trust EMC to even design
a loo cover.

