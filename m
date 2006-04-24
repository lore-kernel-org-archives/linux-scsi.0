From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] iscsi transport endpoint calls
Date: Mon, 24 Apr 2006 12:01:19 -0500
Message-ID: <444D045F.2070901@cs.wisc.edu>
References: <Pine.LNX.4.44.0604111646040.18200-100000@zuben> <444CE6AE.8020502@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:8373 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1750742AbWDXRBV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Apr 2006 13:01:21 -0400
In-Reply-To: <444CE6AE.8020502@voltaire.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Or Gerlitz <ogerlitz@voltaire.com>
Cc: James.Bottomley@SteelEye.com, hch@lst.de, linux-scsi@vger.kernel.org

Or Gerlitz wrote:
> Or Gerlitz wrote:
>> This patch allows for iscsi transport to have its connection being
>> established and disconnected from the kernel.
>>
>> The patch is the sixth iscsi update to 2.6.18 and is needed by iser,
>> it is relative to the five iscsi patches sent by Mike Christie.
>>
>> Doing this is a must for iSER and some of the iscsi offloads but on the
>> other hand not needed for TCP where a socket (fd) is connected in user
>> space
>> and then sent down to the kernel where struct sock is retrieved from
>> the fd.
>>
>> The iscsi user space implementation was enhanced to have a user space
>> transport where TCP is doing things directly from user space and iSER
>> is using the extension to the iscsi u/k IPC ABI to do things in the
>> kernel.
>>
>> Acked-by: Mike Christie <michaelc@cs.wisc.edu>
>> Signed-off-by: Or Gerlitz <ogerlitz@voltaire.com>
> 
> James, Christoph:
> 
> As the iscsi patches sent by Mike Christie were accepted and merged into
> the scsi-misc git tree, this patch is the remaining iscsi related piece
> on which iser is dependent and is not yet accepted for upstream push.
> 
> We really need your feedback on the patch, which allowed us to remove
> the pseudo socket from iser (Christoph is aware to the details).
> 

I was going to send this patch with a update I was making (trying to
send them by the end of the week). I can resend this with my other stuff
if it is ok with everyone.
