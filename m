From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH][RELEASE] megaraid 2.10.2 Driver
Date: Fri, 16 Apr 2004 22:15:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40809336.2060302@pobox.com>
References: <0E3FA95632D6D047BA649F95DAB60E570230C77B@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:39828 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261273AbUDQCPd
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Apr 2004 22:15:33 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E570230C77B@exa-atlanta.se.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Bagalkote, Sreenivas wrote:
>>>ummmm what???    uxferaddr is u32.  why are you casting it to a pointer?
> 
> 
> Both copy_to_user and copy_from_user take pointers, don't they?


Yes, but consider on x86-64 a native pointer is _always_ 32-bit, 
therefore the interface is broken if it assumes the input pointer is 32 
bits.

	Jeff



