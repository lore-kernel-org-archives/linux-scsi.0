From: Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH 2/3] cnic: Add CNIC driver.
Date: Fri, 23 May 2008 13:09:13 -0700
Message-ID: <adalk207pg6.fsf@cisco.com>
References: <1211418386-18203-1-git-send-email-mchan@broadcom.com>
	<1211418386-18203-3-git-send-email-mchan@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-6.cisco.com ([171.71.176.117]:33310 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758737AbYEWUJR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 May 2008 16:09:17 -0400
In-Reply-To: <1211418386-18203-3-git-send-email-mchan@broadcom.com> (Michael
	Chan's message of "Wed, 21 May 2008 18:06:25 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Chan <mchan@broadcom.com>
Cc: davem@davemloft.net, michaelc@cs.wisc.edu, anilgv@broadcom.com, netdev@vger.kernel.org, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com

 > +config CNIC
 > +	tristate "Broadcom CNIC support"
 > +	depends on BNX2

I suspect you'll need a "depends on INET" somewhere (probably here, but
maybe only for the iSCSI part).

 - R.
