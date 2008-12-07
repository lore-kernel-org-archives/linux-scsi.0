From: "Karen Xie" <kxie@chelsio.com>
Subject: RE: [Fwd: Re: iscsi update for 2.6.29]
Date: Sat, 6 Dec 2008 23:14:50 -0800
Message-ID: <8A71B368A89016469F72CD08050AD334D71369@maui.asicdesigners.com>
References: <4935764C.4080007@cs.wisc.edu> <8A71B368A89016469F72CD08050AD33403E32F0A@maui.asicdesigners.com> <49364476.5010608@panasas.com> <493646CB.5080602@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.22.49.110]:3273 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbYLGHSQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Dec 2008 02:18:16 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

Hi, Boaz,

I've just sent the patch out to the list, you can apply the patch to the cxgb3i branch of Mike's linux-2.6-iscsi tree. The patchset includes a file cxgb3i.txt in Document/scsi. I hope it addresses some of your comments.

And, yes, I am interested to have bidi setup. How do I go about getting and setting up the OSD sw target?

Thanks,
Karen

-----Original Message-----
From: Boaz Harrosh [mailto:bharrosh@panasas.com]
Sent: Wed 12/3/2008 12:43 AM
To: Karen Xie
Cc: linux-scsi@vger.kernel.org; michaelc@cs.wisc.edu
Subject: Re: [Fwd: Re: iscsi update for 2.6.29]
 
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

