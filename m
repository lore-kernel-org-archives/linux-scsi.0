From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [patch 00/11] Updated zfcp patches for 2.6.27
Date: Wed, 2 Jul 2008 13:31:53 +0200
Message-ID: <20080702113152.GA17696@schmichrtp.de.ibm.com>
References: <20080702085630.473635000@de.ibm.com> <1214992150.4974.16.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.de.ibm.com ([195.212.29.157]:16585 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128AbYGBLck (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jul 2008 07:32:40 -0400
Content-Disposition: inline
In-Reply-To: <1214992150.4974.16.camel@subratamodak.linux.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Subrata Modak <subrata@linux.vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, ltp-list <ltp-list@lists.sourceforge.net>

On Wed, Jul 02, 2008 at 03:19:10PM +0530, Subrata Modak wrote:
> Hi Christof,
> 
> Do you have testcases (Automated/Can-be-Automated) for testing this
> Device driver? If yes, would you like to contribute the same to LTP
> (http://ltp.cvs.sourceforge.net/ltp/ltp/testcases/kernel/device-drivers/)
> under GPLv2. I would also request test cases in device drivers category,
> which can be a good candidate for contribution.
> 
> Recently i have been trying to revive the device drivers tests in LTP,
> but still hoping to receive something new from somebody.
> 
> Regards--
> Subrata

Subrata,

the standard tests include error injection on various layers in the
I/O path (e.g. storage system, SAN, FCP adapter) and see that this is
recovered automatically while running I/O.

The test teams here with IBM have more experience with the details, i
will try to give you some contact names.

Christof
