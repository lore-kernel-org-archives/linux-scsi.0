From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: emulex FC driver on ppc64
Date: Sat, 10 Apr 2004 20:44:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40789503.4080208@pobox.com>
References: <3356669BBE90C448AD4645C843E2BF2802C01652@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:7584 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262193AbUDKApK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Apr 2004 20:45:10 -0400
In-Reply-To: <3356669BBE90C448AD4645C843E2BF2802C01652@xbl.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.com>
Cc: 'Anton Blanchard' <anton@samba.org>, linux-scsi@vger.kernel.org

Smart, James wrote:
> Anton,
> 
> Thanks for the feedback. I know we've only recently been working things out
> on the PPC64.  Most of the things look pretty minor - we should be able to
> get them in shortly. As for the MAX 32 - we've been looking at raising the
> count as well, but prioritized it below all the other work items we've got
> on the current list.

I think you misunderstand Anton's suggestion, which I agree with:

If you dynamically allocate the structures, there is no need for any 
limit at all.  Most Linux drivers dynamically allocate these structures 
already, but a few (mostly simple) drivers do not.

In the future, dynamic allocation of these types of structures will be a 
requirement, in order to proper object lifetime (ref counting etc.) 
management.

	Jeff


