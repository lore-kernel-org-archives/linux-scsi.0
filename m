From: Ron Eisler <Ron.Eisler@ca.weatherford.com>
Subject: Re: [ PATCH 0/3 ] mpt fusion enhancements
Date: Thu, 21 Jun 2012 21:20:01 +0000 (UTC)
Message-ID: <loom.20120621T230838-721@post.gmane.org>
References: <200902061408.46652.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54239 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760408Ab2FUVZJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jun 2012 17:25:09 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1ShosC-00072g-UU
	for linux-scsi@vger.kernel.org; Thu, 21 Jun 2012 23:25:05 +0200
Received: from a72-29-250-40.enmaxenvision.net ([a72-29-250-40.enmaxenvision.net])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Thu, 21 Jun 2012 23:25:04 +0200
Received: from Ron.Eisler by a72-29-250-40.enmaxenvision.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Thu, 21 Jun 2012 23:25:04 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Bernd Schubert <bs <at> q-leap.de> writes:

> 
> Here are 3 patches for the mpt fusion driver.
> 

Hello Bernd,

I am looking mpt fusion backport fixes for the LSI 53C1030 that will run with
Linux kernel 2.6.27.62. Current version is 3.04.07. Our problem is that running
on VMWare VSphere, with the SAN heavily loaded, we get SCSI timeouts.

Ex. mptscsih: ioc0: attempting task abort! (sc-ffff...)
    sd 0:0:0:0: [sda] CDB: Read (10): 28 00 ...
    mptscsih: ioc0: task abort: Success (sc=ffff...)

The system hangs for 30 seconds on each one.

I see comments/patches here: http://comments.gmane.org/gmane.linux.scsi/48215

Do you have source that would work for 2.6.27.62?

Thank you
Ron Eisler



