From: Jan-Frode Myklebust <janfrode@parallab.uib.no>
Subject: Re: qla2300 failed to initialize adapter on 2.6.7-rc3
Date: Tue, 8 Jun 2004 23:38:16 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040608213816.GA6942@ii.uib.no>
References: <B179AE41C1147041AA1121F44614F0B0DD020E@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eik.ii.uib.no ([129.177.16.3]:17309 "EHLO eik.ii.uib.no")
	by vger.kernel.org with ESMTP id S265382AbUFHViU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2004 17:38:20 -0400
Content-Disposition: inline
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0DD020E@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Jun 08, 2004 at 11:34:14AM -0700, Andrew Vasquez wrote:
> 
> Try out the attached patch -- this should be safe and corrects a small
> oversight on my part when dealing with configure_fabric() failure
> statuses.

Great, thanks!

Unfortunately I woun't be able to try it before the coming weekend,
but I'll let you know how it works as soon as it's tested. 


  -jf
