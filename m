From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [usb-storage] Re: [PATCH] SCSI: limit mode sense usage
Date: Tue, 28 Oct 2003 23:27:34 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031028232734.A15855@beaverton.ibm.com>
References: <1067376788.1056.5.camel@ronald.kuetemeier.com> <Pine.LNX.4.44L0.0310281737350.6912-100000@ida.rowland.org> <20031028175157.A14803@beaverton.ibm.com> <1067393780.1469.9.camel@ronald.kuetemeier.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:30396 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S261906AbTJ2H2S
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2003 02:28:18 -0500
Content-Disposition: inline
In-Reply-To: <1067393780.1469.9.camel@ronald.kuetemeier.com>; from ronald@kuetemeier.com on Tue, Oct 28, 2003 at 07:16:21PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Ronald Kuetemeier <ronald@kuetemeier.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@one-eyed-alien.net>

On Tue, Oct 28, 2003 at 07:16:21PM -0700, Ronald Kuetemeier wrote:

> > The scsi_dev_flags overrides the host adapter setting, and we did not tell
> > it to skip page 8. Since it worked it does not matter, but we could have
> > used (given BLIST_MS_SKIP_PAGE_08 is 0x2000 and BLIST_MS_SKIP_PAGE_3F is
> > 0x4000):

> Patrick,
> isn't BLIST_MS_SKIP_PAGE_08 always turned "on"?

No, see scsi_devinfo.c scsi_get_device_flags, it can override the
shost->flags value. So if wanted we could set it to zero via
/proc/scsi/device_info or scsi_dev_flags.

-- Patrick Mansfield
