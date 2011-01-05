From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 5/8] BNX2I: Added TCP timestamps option support
Date: Wed, 05 Jan 2011 15:06:13 -0600
Message-ID: <4D24DD45.8060701@cs.wisc.edu>
References: <Eddie Wai <eddie.wai@broadcom.com> <1294260267-17413-6-git-send-email-eddie.wai@broadcom.com> <4D24DA01.9060709@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:40954 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360Ab1AEVJP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Jan 2011 16:09:15 -0500
In-Reply-To: <4D24DA01.9060709@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: Eddie Wai <eddie.wai@broadcom.com>, James Bottomley <JBottomley@novell.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>

On 01/05/2011 02:52 PM, Mike Christie wrote:
> On 01/05/2011 02:44 PM, Eddie Wai wrote:
>> This TCP timestamps option is a module wise feature which can be
>> enabled via the module param (time_stamps). Once enabled, the TCP
>> connection will advertise timestamps as an option to get negotiated.
>>
>
> Is there any reason this has to be module wide? Can the hw support
> having it per connection?
>

Oh yeah, what other tcp settings do you guys have? And do you have 
something like a send/recv window setting?


