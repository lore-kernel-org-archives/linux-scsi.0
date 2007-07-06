From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 3/4] Enable link power management for ata drivers
Date: Thu, 05 Jul 2007 20:00:47 -0400
Message-ID: <468D862F.2030604@garzik.org>
References: <20070705194909.337398431@intel.com>	<20070705130530.5873afeb.kristen.c.accardi@intel.com> <20070705153334.08402809.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:52108 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbXGFAAw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jul 2007 20:00:52 -0400
In-Reply-To: <20070705153334.08402809.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, James.Bottomley@steeleye.com, edwintorok@gmail.com, axboe@kernel.dk, linux-scsi@vger.kernel.org

Andrew Morton wrote:
> On Thu, 5 Jul 2007 13:05:30 -0700
> Kristen Carlson Accardi <kristen.c.accardi@intel.com> wrote:
> 
>> +	ATA_DFLAG_IPM		= (1 << 6), /* device supports interface PM */
>>  	ATA_DFLAG_CFG_MASK	= (1 << 8) - 1,
> 
> I had to bump this to (1<<7), so we've run out.

You can shuffle the numbers a bit, as long as the masks (*_MASK) stay 
correct for their purpose

	Jeff



