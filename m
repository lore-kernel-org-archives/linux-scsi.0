From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH] scsi, mptsas : drop scsi_host lock when calling
 mptsas_qcmd
Date: Thu, 16 Sep 2010 14:18:08 -0700
Message-ID: <1284671888.7280.87.camel@schen9-DESK>
References: <1284666254.7280.54.camel@schen9-DESK>
	 <1284670136.13344.93.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:37583 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350Ab0IPVQ6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Sep 2010 17:16:58 -0400
In-Reply-To: <1284670136.13344.93.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Eric Moore <Eric.Moore@lsi.com>, linux-scsi@vger.kernel.org, vasu.dev@intel.com, ak@linux.intel.com, willy@linux.intel.com

On Thu, 2010-09-16 at 13:48 -0700, Nicholas A. Bellinger wrote:

> 
> I asked James about getting Vasu's unlocked_qcmds=1 patch merged, but he
> convinced me that doing conditional locking while is very simple, is not
> the proper way for getting this resolved in mainline code.  I think in
> the end this will require a longer sit down to do a wholesale conversion
> of all existing SCSI LLD drivers, and identifing the broken ones that
> still need a struct Scsi_Host->host_lock'ed SHT->queuecommand() for
> whatever strange & legacy reasons.

That certainly sounds like the right way to go.

> While there are still some outstanding TCM items that need to be
> resolved in the next days, I am very interested to help make the
> wholesale host_lock + ->queuecomamnd() conversion happen.  I will get a
> lio-core-2.6.git branch setup for this purpose on .36-rc4 soon and start
> working on the main SCSI Mid-layer conversion pieces sometime next week.
> I am very eager to accept patches on a per LLD basis for this work, and
> will be starting with the open-fcoe initiator, TCM_Loop, mpt2sas, and
> open-iscsi.
> 
> I think the wholesole conversion is going to be pretty straight-forward,
> and at least with the main SCSI LLDs (that we really care about ;) there
> appear to be no immediate issues with a full conversion.
> 

Looking forward to it.  Thanks.

Tim



