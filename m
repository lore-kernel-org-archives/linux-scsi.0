From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Thin provisioning & arrays
Date: Tue, 11 Nov 2008 08:59:31 -0500
Message-ID: <49198FC3.7080301@redhat.com>
References: <28572.1226369378@ocs10w>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37875 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756170AbYKKOAI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Nov 2008 09:00:08 -0500
In-Reply-To: <28572.1226369378@ocs10w>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Keith Owens <kaos@ocs.com.au>
Cc: Black_David@emc.com, david@fromorbit.com, dwmw2@infradead.org, martin.petersen@oracle.com, chris.mason@oracle.com, jens.axboe@oracle.com, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, coughlan@redhat.com, matthew@wil.cx

Keith Owens wrote:
> On Mon, 10 Nov 2008 20:23:17 -0500, 
> Black_David@emc.com wrote:
>   
>> Dave,
>> The thin provisioning chunk size (coming) in the VPD page is a
>> possible place to start.
>>     
>
> VPD page for which device?  Consider a filesystem that is striped
> across devices from multiple arrays or even multiple vendors.  How is
> the filesystem supposed to "align" an unmap command when the underlying
> disks all have different alignments?
>
>   

I think that we are losing focus on the core use case here. Big arrays 
that implement thin luns also implement RAID in the box. If you are 
building a clustered file system, it would be extremely unlikely to 
build it with storage from different vendors.

You always have the option to disable thin luns or simply fully 
provision LUN's for more complex situations.

Thing is being pitched to answer a very specific customer use case - 
shared storage (mid to high end almost exclusively) with several 
different users and applications....

ric

