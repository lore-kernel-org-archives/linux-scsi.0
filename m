From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/5]: Proposal for iSCSI Network Configuration
Date: Mon, 28 Feb 2011 02:14:19 -0600
Message-ID: <4D6B595B.4000109@cs.wisc.edu>
References: <5E4F49720D0BAD499EE1F01232234BA8722624A352@AVEXMB1.qlogic.org> <4D6B0781.1050403@cs.wisc.edu> <5E4F49720D0BAD499EE1F01232234BA87226303BCC@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:49497 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463Ab1B1IOb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Feb 2011 03:14:31 -0500
In-Reply-To: <5E4F49720D0BAD499EE1F01232234BA87226303BCC@AVEXMB1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>, James Bottomley <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Harish Zunjarrao <harish.zunjarrao@qlogic.com>, Manish Rangankar <manish.rangankar@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

On 02/28/2011 12:02 AM, Vikas Chaudhary wrote:
> - We still need the BSG interface, which we are working on our side, to get the
>    adapter FLASH related read/write operations.

So would that be the operations to do something like store/get targets, 
discovery info, isns, chap, iscsi settings like FirstBurst, etc?
