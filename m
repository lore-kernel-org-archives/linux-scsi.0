From: jim owens <jowens@hp.com>
Subject: Re: Thin provisioning & arrays
Date: Tue, 11 Nov 2008 18:52:02 -0500
Message-ID: <491A1AA2.3070908@hp.com>
References: <28572.1226369378@ocs10w> <49198FC3.7080301@redhat.com> <49199CFF.8080002@hp.com> <20081111230852.GM2373@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0026.austin.hp.com ([15.216.28.33]:44954 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbYKKXwI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Nov 2008 18:52:08 -0500
In-Reply-To: <20081111230852.GM2373@disturbed>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jim owens <jowens@hp.com>, Ric Wheeler <rwheeler@redhat.com>, Keith Owens <kaos@ocs.com.au>, Black_David@emc.com, dwmw2@infradead.org, martin.petersen@oracle.com, chris.mason@oracle.c

Dave Chinner wrote:
> On Tue, Nov 11, 2008 at 09:55:59AM -0500, jim owens wrote:
>> Ric Wheeler wrote:
>>> Thing is being pitched to answer a very specific customer use case -  
>>> shared storage (mid to high end almost exclusively) with several  
>>> different users and applications....
> ...
>> It is up to the customer to manage their storage so it never
>> reaches the unable-to-write state.
> 
> Sure, but putting the entire management burden of obtaining and
> running defrag tools in every one of their large set of OS's is the
> wrong approach.
> 
> We can and should be designing new functionality for the data center
> in such a manner that does not require large scale manual
> intervention to maintain the systems. Your customers won't thank you
> for solving the thin provisioning management problem by requiring
> them to do extra hand-holding....

I agree that it could be done better.

I just don't expect that to happen any time soon because
both multiple array vendors and multiple OS vendors must
agree and spend money when they don't see this as a large
amount of missed opportunity money.  You only have to be
as good as your competition and the customers are used to
doing the extra hand-holding.

All we can do is support what the devices will do today
with minimal effort and wait for customer demand to force
everyone to make improvements.

jim
