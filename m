From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: new runtime scsi warnings in 2.6.24-rc6+git
Date: Sat, 12 Jan 2008 20:58:55 +0100
Message-ID: <200801122058.55750.rjw@sisk.pl>
References: <Pine.SOC.4.64.0801041231320.15055@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:34359 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706AbYALT41 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Jan 2008 14:56:27 -0500
In-Reply-To: <Pine.SOC.4.64.0801041231320.15055@math.ut.ee>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Friday, 4 of January 2008, Meelis Roos wrote:
> Todays git gives the following warning during bootup on a Intel 845+PATA 
> PC (using libata to drive PATA):
> 
> Driver 'sd' needs updating - please use bus_type methods
> Driver 'sr' needs updating - please use bus_type methods

They are due to commit 751bf4d7865e4ced406be93b04c7436d866d3684, AFAICS, and
they don't mean anything wrong.

Thanks,
Rafael
