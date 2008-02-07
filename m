From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: no INQUIRY from userspace please (was Re: [PATCH 7/9] scsi_dh: Add support for SDEV_PASSIVE)
Date: Thu, 7 Feb 2008 12:42:31 -0800 (PST)
Message-ID: <157925.90863.qm@web31814.mail.mud.yahoo.com>
References: <1202396490.3171.8.camel@localhost.localdomain>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31814.mail.mud.yahoo.com ([68.142.206.167]:25620 "HELO
	web31814.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755327AbYBGUmg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Feb 2008 15:42:36 -0500
In-Reply-To: <1202396490.3171.8.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, Mike Christie <michaelc@cs.wisc.edu>, sekharan@us.ibm.com, dm-devel@redhat.com, linux-scsi@vger.kernel.org, jens.axboe@oracle.com

--- On Thu, 2/7/08, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> This is all a tradeoff.  If you want userspace *never* to
> issue raw SCSI
> commands like INQUIRY, we're going to have to provide
> the needed
> information from the kernel via sysfs ... including VPD
> strings.  This
> is something we've always shovelled off into userspace
> before.

What if a user-space application client _does_ send an INQUIRY to
a device anyway?

It would probably be better to preserve application client behaviour
and simulate/emulate n-th INQUIRY, after the 1st for such broken
device firmwares that break on any subsequent INQUIRY.  Possibly
in the LLDD or via blacklisting in the mid-layer.

   Luben

