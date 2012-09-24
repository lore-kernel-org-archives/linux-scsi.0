From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCHv2] st: remove st_mutex
Date: Mon, 24 Sep 2012 10:16:25 -0700
Message-ID: <50609569.4040304@suse.com>
References: <504E6B7C.9010407@suse.com> <1348477560.2467.23.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:48895 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab2IXRQb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Sep 2012 13:16:31 -0400
In-Reply-To: <1348477560.2467.23.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

On 09/24/2012 02:06 AM, James Bottomley wrote:
> On Mon, 2012-09-10 at 15:36 -0700, Lee Duncan wrote:
>> From: Hannes Reinecke <hare@suse.com>
>>
>> The st_mutex was created when the BKL was removed, and
>> prevents simultaneous st_open calls. It is better to
>> protect just the necessary data.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> Reviewed-by: Lee Duncan <lduncan@suse.com>
> 
> That should be Signed-off-by since you sent the patch to me.  Signoffs
> have to follow the chain of transmission.  I've assumed this was just a
> mistype.
> 
> James

Thank you James.

-- 
Lee Duncan
