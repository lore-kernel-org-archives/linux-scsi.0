From: dann frazier <dannf@dannf.org>
Subject: Re: [PATCH] Use legacy driver for NetRAID 1M/2M controllers
Date: Wed, 19 Sep 2007 13:23:01 -0600
Message-ID: <20070919192300.GG21004@ldl.fc.hp.com>
References: <20070919010441.GA4802@ldl.fc.hp.com> <0631C836DBF79F42B5A60C8C8D4E8229C97E9E@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlrel6.hp.com ([156.153.255.205]:34803 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbXISTWC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Sep 2007 15:22:02 -0400
Content-Disposition: inline
In-Reply-To: <0631C836DBF79F42B5A60C8C8D4E8229C97E9E@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Patro, Sumant" <Sumant.Patro@lsi.com>
Cc: DL-MegaRAID Linux <megaraidlinux@lsi.com>, linux-scsi@vger.kernel.org

On Wed, Sep 19, 2007 at 12:46:02PM -0600, Patro, Sumant wrote:
> NACK.
> 
> ID being added is already supported in megaraid_mbox driver.
> Please use megaraid_mbox driver. 


Understood. The problem is that the megaraid_mbox driver is not
working for various cards with these IDs, whereas the legacy driver is
believed to work for all of them.

Note that this patch also alters megaraid_mbox to avoid an overlap in
device support.

I've sent a call out to the various reporters to find out what exactly
the failure mode(s) is with megaraid_mbox, which can be found in the
bug report:

  http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=317258

So far there's just one response about timeouts during
initialization. I expect to see at least one more response this week.
