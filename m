From: stefan@mdy.univie.ac.at (Stefan Boresch)
Subject: Re: queued patches for SCSI for 2.6.24
Date: Wed, 26 Sep 2007 10:50:20 +0200
Message-ID: <20070926085020.GC1606@loop.mdy.univie.ac.at>
References: <1190768402.8707.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from epsilon.mdy.univie.ac.at ([131.130.40.18]:40911 "EHLO
	epsilon.mdy.univie.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbXIZIuY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Sep 2007 04:50:24 -0400
Content-Disposition: inline
In-Reply-To: <1190768402.8707.20.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Sep 25, 2007 at 08:00:02PM -0500, James Bottomley wrote:
> Andrew asked that I provide a status report of pending updates.  The
> list is attached below.  It's pretty much driver updates and minor bug
> fixes.  The main functionality changes are Kay's sysfs updates and the
> shift of the ULD attachement towards the block prep function.
> 

[snip]

Just curious: Is the patch for scsi_transport_spi.c you sent me for my
hardware problem going to make it into an official kernel?

(Referring to your patch which you posted under:

[PATCH] scsi_transport_spi: fix domain validation failure from
incorrect width setting

)

Arguably, it works around a hardware problem of mine, but it
could make also for others the differences of a machine not
booting at all and one that at least comes up and is usable ...

Sincerely,

Stefan Boresch

-- 
Stefan Boresch
Institute for Computational Biological Chemistry
University of Vienna, Waehringerstr. 17       A-1090 Vienna, Austria
Phone: -43-1-427752715                        Fax:   -43-1-427752790
