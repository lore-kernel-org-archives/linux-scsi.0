From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] aic94xx: Widens the Range of Recognized FLASH Manufactures
Date: Wed, 6 Sep 2006 15:29:57 -0700
Message-ID: <20060906222957.GA17348@us.ibm.com>
References: <1157473228.7906.13.camel@localhost.localdomain> <20060906062438.72183.qmail@web31810.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:19937 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751759AbWIFW37
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Sep 2006 18:29:59 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e33.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id k86MTweB025180
	for <linux-scsi@vger.kernel.org>; Wed, 6 Sep 2006 18:29:58 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k86MTwtL371082
	for <linux-scsi@vger.kernel.org>; Wed, 6 Sep 2006 16:29:58 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k86MTwwO015830
	for <linux-scsi@vger.kernel.org>; Wed, 6 Sep 2006 16:29:58 -0600
Content-Disposition: inline
In-Reply-To: <20060906062438.72183.qmail@web31810.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: Alexis Bruemmer <alexisb@us.ibm.com>, linux-scsi@vger.kernel.org

Luben Tuikov <ltuikov@yahoo.com> wrote:
> Flash part discovery and interfacing can be *generalized*
> in all of the following ways:
>         a) by flash part manufacturer, and
>         b) by flash part interface (8 or 8/16 bit), and
>         c) by how the flash part is connected to the chip.
> In other words, there exists flash part discovery and interface code
> which is flash part manufacturer agnostic, 8/16 bit part agnostic
> and connection agnostic.
> 
> For the aic94xx you may not need such an enterprise level solution,
> (since you'd need to know intricate details about the HW design),
> but you can _still generalize per sequence_, in which case you'd
> not need to know anything about the manufacturer of the flash part.
> That is, you can at least generalize by manufacturer, so that
> you wouldn't need the switch() { case ...} statements at all.
> 

In looking through the code I cannot see any user of the data we obtain
from the flash. It appears that we could simplify the function to just a
check for FLASHEX unless I am missing something.

-andmike
--
Michael Anderson
andmike@us.ibm.com
