From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [dm-devel] [multipath] SCSI device capacity mess
Date: Thu, 28 Oct 2004 11:14:36 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041028181436.GA18874@beaverton.ibm.com>
References: <1098833278.4914.24.camel@zezette> <20041027081713.GC32712@marowsky-bree.de> <1098903759.12464.32.camel@zezette> <1098914250.1588.1.camel@mulgrave> <20041028113728.GT32712@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:31195 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S262868AbUJ1SOt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Oct 2004 14:14:49 -0400
Received: from westrelay04.boulder.ibm.com (westrelay04.boulder.ibm.com [9.17.193.32])
	by e34.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id i9SIElJ8367272
	for <linux-scsi@vger.kernel.org>; Thu, 28 Oct 2004 14:14:47 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay04.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id i9SIEjMo114718
	for <linux-scsi@vger.kernel.org>; Thu, 28 Oct 2004 12:14:46 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id i9SIEjGD007703
	for <linux-scsi@vger.kernel.org>; Thu, 28 Oct 2004 12:14:45 -0600
Content-Disposition: inline
In-Reply-To: <20041028113728.GT32712@marowsky-bree.de>
List-Id: linux-scsi@vger.kernel.org
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, christophe varoqui <christophe.varoqui@free.fr>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, Oct 28, 2004 at 01:37:28PM +0200, Lars Marowsky-Bree wrote:

> 
> Can't we do a test-unit-ready before trying to read and then just not
> read the partition table w/o so much noise?

We already issue a TUR in sd_spinup_disk() prior to the READ CAPACITY and
partition reads.

We might not be able to even black list them and not excute specific code
if these devices can be configured differently - they might need special
code (yuck) to query the device and figure out the configuration.

-- Patrick Mansfield
