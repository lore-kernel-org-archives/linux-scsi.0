From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Open-FCoE] deadlock during fc_remove_host
Date: Wed, 20 Apr 2011 22:21:51 -0500
Message-ID: <4DAFA2CF.2080102@cs.wisc.edu>
References: <4DAF7944.6060909@broadcom.com> <4DAF9C15.1010808@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:43665 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139Ab1DUDWG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Apr 2011 23:22:06 -0400
In-Reply-To: <4DAF9C15.1010808@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Cc: Joe Eykholt <jeykholt@cisco.com>, "devel@open-fcoe.org" <devel@open-fcoe.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 04/20/2011 09:53 PM, Mike Christie wrote:
> Is the reason that rport b's terminate_rport_io has not been called,
> because that workqueue is queued behind rport a's workqueue and rport
> b's workqueue function is not called? If so, have you tested this with
> the current upstream kernel?

Oh wait, I think you also need to change the fc class to use 
alloc_workqueue instead of create_singlethread_workqueue.
