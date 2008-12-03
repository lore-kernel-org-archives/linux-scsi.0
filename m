From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [Fwd: Re: iscsi update for 2.6.29]
Date: Wed, 03 Dec 2008 10:43:55 +0200
Message-ID: <493646CB.5080602@panasas.com>
References: <4935764C.4080007@cs.wisc.edu> <8A71B368A89016469F72CD08050AD33403E32F0A@maui.asicdesigners.com> <49364476.5010608@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:21897 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750859AbYLCIn7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2008 03:43:59 -0500
In-Reply-To: <49364476.5010608@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Karen Xie <kxie@chelsio.com>
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

Boaz Harrosh wrote:
> http://groups.google.com/group/open-iscsi/msg/dd660ab6b0def64f?&q=cxgb3i%3A+cxgb3+iSCSI+initiator+boaz
> 
> Karen Xie wrote:
>> Hi, Boaz,
>>
>> Sorry, I must have missed your bidi comment. I tried to search the archive but does not seem to be able to find anything. Do you mind forward me the email if you still have it?
>>
>> Sorry for the inconvenience.
>> Thanks,
>> Karen
>>

Karen Hi.

Please point me to the latest code. Do you have it on a public git/web
based on Mike's latest kernel?

Would you be interested in testing a bidi setup with SW OSD target and
initiator? One machine runs a user-mode target the second an initiator
on top of open-iscsi. This way you can test full bidi and extended cdb
commands.

Thanks
Boaz
