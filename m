From: Roland Dreier <rdreier@cisco.com>
Subject: Re: [RFC][PATCH 1/1] cxgb3i: cxgb3 iSCSI initiator
Date: Mon, 11 Aug 2008 14:41:16 -0700
Message-ID: <adad4kfxm9v.fsf@cisco.com>
References: <adazlnlzc60.fsf@cisco.com>
	<20080809.224637.69833549.davem@davemloft.net>
	<48A08145.6060703@hp.com>
	<20080811.141254.165409473.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-6.cisco.com ([171.71.176.117]:26120 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbYHKVlS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Aug 2008 17:41:18 -0400
In-Reply-To: <20080811.141254.165409473.davem@davemloft.net> (David Miller's
	message of "Mon, 11 Aug 2008 14:12:54 -0700 (PDT)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: rick.jones2@hp.com, jgarzik@pobox.com, swise@opengridcomputing.com, divy@chelsio.com, kxie@chelsio.com, netdev@vger.kernel.org, open-iscsi@googlegroups.com, michaelc@cs.wisc.edu, daisyc@us.ibm.com, wenxiong@us.ibm.com, bhua@us.ibm.com, dm@chelsio.com, leedom@chelsio.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

 > > Probably depends on whether or not the iSCSI offload solutions are doing 
 > > zero-copy receive into the filecache?
 > 
 > That's a data placement issue, which also can be solved with
 > stateless offloading.

How can you place iSCSI data properly with only stateless offloads?

 - R.
