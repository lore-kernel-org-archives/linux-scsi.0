From: Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH 12/14] scsi: use printk_once
Date: Tue, 11 Aug 2009 09:46:48 -0700
Message-ID: <adahbwe70xz.fsf@cisco.com>
References: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com>
	<1249847649-11631-13-git-send-email-marcin.slusarz@gmail.com>
	<1250008813.4301.55.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-6.cisco.com ([171.71.176.117]:48950 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810AbZHKQq5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2009 12:46:57 -0400
In-Reply-To: <1250008813.4301.55.camel@mulgrave.site> (James Bottomley's
	message of "Tue, 11 Aug 2009 11:40:13 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org


 > > -	static int vers_printed;
 > > -
 > > -	if (!vers_printed) {
 > > -		printk(KERN_INFO "%s", version);
 > > -		vers_printed = 1;
 > > -	}
 > > +	printk_once(KERN_INFO "%s", version);

 > There's really no point to this beyond code churn.  Both patterns are
 > correct uses so conversion buys us nothing.

It's a pretty small gain but I do think 6 lines -> 1 line does have value.

 - R.
