From: Olaf Hering <olh@suse.de>
Subject: Re: Fw: SCSI device not spinning up on rw
Date: Tue, 11 Jul 2006 14:57:09 +0200
Message-ID: <20060711125709.GA14741@suse.de>
References: <20060603182302.7136831f.akpm@osdl.org> <44825D9F.9070305@torque.net> <44835AA2.1070809@us.ibm.com> <4484723E.7060906@us.ibm.com> <20060711062049.GA12266@suse.de> <44B39764.3030204@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:14561 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1750735AbWGKM5R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jul 2006 08:57:17 -0400
Content-Disposition: inline
In-Reply-To: <44B39764.3030204@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Brian King <brking@us.ibm.com>, dougg@torque.net, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, Ruben Faelens <parasietje@gmail.com>

 On Tue, Jul 11, Stefan Richter wrote:

> Olaf Hering wrote:
> > On Mon, Jun 05, Brian King wrote:
> >>Brian King wrote:
> ...
> >>>Setting sdev->allow_restart in struct scsi_device will cause sense
> >>>key/code/qual of 02/04/02 (not ready, initialization command required)
> >>>to wake up the scsi error handler and will force scsi core to issue
> >>>a start unit command to the disk. I added this a while back to handle
> >>>ipr raid arrays which need a start unit command each time the adapter
> >>>gets reset.
> ...
> >>Please try the attached patch. It adds a sysfs device attribute 
> >>"allow_restart".
> ...
> >Is it safe to have this attribute be 1 per default, and let the user
> >disable it for problematic drives? The IO errors bother me alot...
> 
> Matthew Dharm pointed out that it may confuse USB devices:
> http://marc.theaimsgroup.com/?l=linux-scsi&m=107702811830956

I found that after I sent this. I'm ok with the current default, it can
be tweaked as needed in the startup scripts.
