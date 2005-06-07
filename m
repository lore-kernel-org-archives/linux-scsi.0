From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: RE: [PATCH RFC 0/4] use scatter lists for all blockpc	requests	and simplify hw handlers
Date: Tue, 7 Jun 2005 14:38:29 -0400
Message-ID: <007e01c56b90$1a09a6f0$e0019d89@cybernetics.com>
References: <1118162097.4813.38.camel@mulgrave>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cyborg.cybernetics.com ([206.246.200.18]:55304 "EHLO
	cyborg.cybernetics.com") by vger.kernel.org with ESMTP
	id S261855AbVFGSiU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Jun 2005 14:38:20 -0400
In-Reply-To: <1118162097.4813.38.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@SteelEye.com>
Cc: 'Douglas Gilbert' <dougg@torque.net>, 'Mike Christie' <michaelc@cs.wisc.edu>, 'device-mapper development' <dm-devel@redhat.com>, 'linux-scsi' <linux-scsi@vger.kernel.org>, 'Jens Axboe' <axboe@suse.de>, LIRANS@il.ibm.com

> > My company (Cybernetics) sells several products that run embedded
Linux
> > which use the userspace scatter-gather capability of the SG driver.
> > They are still running the 2.4 kernel series, but we will probably
> > switch to 2.6 at some point.
>
> What do they actually use it for?  As in why is the data scattered
even
> in the virtual address space?

One of our products is a RAID-like controller for SCSI tape drives.
Parallel SCSI or iSCSI in via a target-mode SCSI driver and parallel
SCSI, iSCSI, or FC out via the SG driver, with various functions in
between for data buffering, emulation, striping, mirroring, etc.  The
program that controls everything has a complex internal buffering scheme
that uses userspace scatter-gather for the main read/write I/O path to
the tape drives.

Anthony J. Battersby
Cybernetics

