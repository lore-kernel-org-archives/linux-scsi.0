From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [dm-devel] [RFC PATCH 0/4] dm-mpath: dynamic load balancers
Date: Thu, 29 Jan 2009 12:12:17 -0600
Message-ID: <4981F181.2090905@cs.wisc.edu>
References: <20080912.105038.102581623.k-ueda@ct.jp.nec.com>	<20090128153704.GA23158@agk.fab.redhat.com> <498157D1.2010105@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:51242 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528AbZA2SMk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jan 2009 13:12:40 -0500
In-Reply-To: <498157D1.2010105@ct.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, stefan.bader@canonical.com, linux-scsi@vger.kernel.org

Kiyoshi Ueda wrote:
> Hi Alasdair,
> 
> On 01/29/2009 12:37 AM +0900, Alasdair G Kergon wrote:
>> On Fri, Sep 12, 2008 at 10:50:38AM -0400, Kiyoshi Ueda wrote:
>>> The following patches add the following 2 dynamic load balancers
>>> to request-based dm-multipath:
>>>   o queue-length oriented dynamic load balancer, dm-queue-length.
>>>   o service-time oriented dynamic load balancer, dm-service-time.
>>  
>> Could we have separate Kconfig options to select them?
> 
> Sure.
> I posted the new one rebased on top of 2.6.29-rc2:
>   https://www.redhat.com/archives/dm-devel/2009-January/msg00183.html
>   https://www.redhat.com/archives/dm-devel/2009-January/msg00186.html
> 

For the Kconfig help, is there something we could add to help people 
know when to choose one or the other? Sort of like how the block layer 
io scheduler (block/Kconfig.iosched) says one might be helpful for 
desktops and one is useful for data bses?
