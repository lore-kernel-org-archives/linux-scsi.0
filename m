From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 17/18] srp_transport: Add transport layer recovery support
Date: Mon, 16 Jul 2012 16:29:46 -0600
Message-ID: <500495DA.8080605@cs.wisc.edu>
References: <3109536.qySrY1Ts3e@asus> <2536946.Diyz1JQnfo@asus> <500490A5.7020202@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:34924 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322Ab2GPWaB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2012 18:30:01 -0400
In-Reply-To: <500490A5.7020202@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, brking@linux.vnet.ibm.com, dillowda@ornl.gov

On 07/16/2012 04:07 PM, Mike Christie wrote:
> For the ping code, does it use TUR because there is not a transport way
> to test the path/port/transport/interconnect?

Maybe not transport as in SCSI transport method, but what about
something similar to using a ICMP ping for testing the network with iscsi.
