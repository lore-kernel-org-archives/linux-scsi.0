From: "Karen Xie" <kxie@chelsio.com>
Subject: RE: [PATCH 0/3 2.6.29] cxgb3i -- driver fixes & updates
Date: Mon, 8 Dec 2008 09:47:35 -0800
Message-ID: <8A71B368A89016469F72CD08050AD33403F15143@maui.asicdesigners.com>
References: <200812070709.mB779a5T020861@localhost.localdomain> <20081206.235356.237924993.davem@davemloft.net> <8A71B368A89016469F72CD08050AD334D7136A@maui.asicdesigners.com> <493D43AE.8090404@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.22.49.110]:14659 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbYLHRrd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Dec 2008 12:47:33 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: David Miller <davem@davemloft.net>, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, James.Bottomley@HansenPartnership.com

Hi, Mike,

Thanks for the reply.

True, there is no dependency on the network driver part.

I will send out the new patch with the entire driver soon.

Thanks,
Karen

-----Original Message-----
From: Mike Christie [mailto:michaelc@cs.wisc.edu] 
Sent: Monday, December 08, 2008 7:57 AM
To: Karen Xie
Cc: David Miller; linux-scsi@vger.kernel.org;
open-iscsi@googlegroups.com; James.Bottomley@HansenPartnership.com
Subject: Re: [PATCH 0/3 2.6.29] cxgb3i -- driver fixes & updates

Karen Xie wrote:
> Hi, Dave & Mike,
> 
> I guess I need some clarification on how this driver code could be
merged.
> 

I think you want to send a patch with the entire driver like you were 
before. Do not send against my branch so James and others do not have to

dig around in there.


> The cxgb3i driver addition consists of 2 parts:
> 
> 1. the new cxgb3i driver. It resides under drivers/scsi, this part has
the dependency on the open-iscsi core changes I referred in the previous
email. I was under the impression this goes into scsi-misc?
> 
> 2. some iscsi related changes in cxgb3 driver (driver/net). This part
does not have any dependency. Dave, I suppose this part goes into
net-next? If so, this does not need Mike's patch at all.
> 

There is no dependency with network stuff right (just the cxgb3 driver 
which is upstream already)? If so I think it would be easier to just 
send the driver through James.


> Thanks a lot.
> Karen
> 
> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Sat 12/6/2008 11:53 PM
> To: Karen Xie
> Cc: linux-scsi@vger.kernel.org; open-iscsi@googlegroups.com;
michaelc@cs.wisc.edu; James.Bottomley@HansenPartnership.com
> Subject: Re: [PATCH 0/3 2.6.29] cxgb3i -- driver fixes & updates
>  
> From: Karen Xie <kxie@chelsio.com>
> Date: Sat, 6 Dec 2008 23:09:36 -0800
> 
>> It is based on the cxgb3i branch of Mike's linux-2.6-iscsi tree. It
needs the
>> patch Mike sent several days ago on preparing the iscsi core libary
for pdu
>> offload (http://marc.info/?l=linux-scsi&m=122819956917473).
> 
> If this dependency exists I probably can't pull this into the
> net-next-2.6 then, just FYI but you probably already understand
> this :-)
> 

