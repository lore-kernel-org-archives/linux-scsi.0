From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [dm-devel] [multipath] SCSI device capacity mess
Date: Fri, 29 Oct 2004 18:01:31 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041030010131.GA30336@beaverton.ibm.com>
References: <1098833278.4914.24.camel@zezette> <20041027081713.GC32712@marowsky-bree.de> <1098903759.12464.32.camel@zezette> <1098914250.1588.1.camel@mulgrave> <20041028113728.GT32712@marowsky-bree.de> <20041028181436.GA18874@beaverton.ibm.com> <20041028182154.GY32712@marowsky-bree.de> <20041030004131.GA29908@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:12220 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263565AbUJ3BBx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Oct 2004 21:01:53 -0400
Content-Disposition: inline
In-Reply-To: <20041030004131.GA29908@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, christophe varoqui <christophe.varoqui@free.fr>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, Oct 29, 2004 at 05:41:31PM -0700, Patrick Mansfield wrote:
> 
> What is the result of the TUR? I did not see any information about it in other posts in this thread.
> 

Also, if the device is already showing up you can just send a TUR via sg,
you don't have to hack sd.c.

I think the sg_turs command in sg_utils might tell us enough information
on error, though I don't have any non-ready or borken devices readily
available.

elm3a211:~ # sg_turs  /dev/sdb
Completed 1 Test Unit Ready commands with 0 errors

-- Patrick Mansfield
