From: Tony Battersby <tonyb@cybernetics.com>
Subject: Re: [PATCH] sym53c8xx_2: slave_alloc/destroy safety (2.6.27.5)
Date: Wed, 07 Jan 2009 09:52:31 -0500
Message-ID: <4964C1AF.3020103@cybernetics.com>
References: <49593940.9060102@cybernetics.com>	 <1230631843-16470-1-git-send-email-Aaro.Koskinen@nokia.com> <1230664572.18627.2.camel@localhost.localdomain> <4963861F.5090404@cybernetics.com> <49648AA3.5070401@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([98.174.209.230]:3796 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbZAGOwd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jan 2009 09:52:33 -0500
In-Reply-To: <49648AA3.5070401@nokia.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaro Koskinen <aaro.koskinen@nokia.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

Aaro Koskinen wrote:
> Hello,
>
> ext Tony Battersby wrote:
>   
>> From the description of this patch, I assume that it is a cleanup
>> instead of a fix for an actual problem.  Correspondingly, I don't have a
>> specific testcase that is improved by this patch.  I also have not
>> analyzed the source to see what the patch is trying to do.  However, the
>> current form of the patch passes testing as described above.
>>     
>
> You can try to do the following test with and without the patch:
>
> echo "scsi remove-single-device some_valid_address_with_a_target > 
> /proc/scsi/scsi"
>
> Then do e.g. "resetdev" or "cleardev" to that target through the drivers 
> /proc interface.
>
> A.
>
>   
OK, I just tested that and verified that your patch fixes it.  Thanks!

Tony

