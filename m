From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [osd-dev] [PATCH 04/18] libosd: OSDv1 preliminary implementation
Date: Sun, 09 Nov 2008 16:55:49 +0200
Message-ID: <4916F9F5.9040409@panasas.com>
References: <491073BB.4000900@panasas.com>	<1225817069-5969-1-git-send-email-bharrosh@panasas.com>	<20081104180347.GA9818@uranus.ravnborg.org> <49119BAF.6040603@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:26771 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754800AbYKIOzl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Nov 2008 09:55:41 -0500
In-Reply-To: <49119BAF.6040603@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sam Ravnborg <sam@ravnborg.org>
Cc: open-osd development <osd-dev@open-osd.org>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, Sami.Iren@seagate.com, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Randy Dunlap <randy.dunlap@oracle.com>

Boaz Harrosh wrote:
> Sam Ravnborg wrote:
>>> +EXPORT_SYMBOL(osd_dev_init);
>> kernel-doc comments for all exported funtions / variables.
>>
> 
> I have some kernel-doc comments of exported functions in the Header
> file. I have not yet finished all of them. (Laziness on my part).
> 
> Are kernel-doc comments in headers a big NO-NO. I like it this way,
> so when I have to learn a new Library all the information
> I need to know is in the header. Also the header is a much better place
> when you do programing by shopping, that is you don't know what you need
> and you look for what's available.
> 
> Thanks
> Boaz

Sam please comment if kernel-doc comments are OK in headers

Thanks
Boaz
