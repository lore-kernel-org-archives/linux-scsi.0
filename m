From: Don Brace <brace77070@gmail.com>
Subject: Re: [PATCH 1 02/25] hpsa: remove unused hpsa_tag_discard_error_bits
Date: Thu, 29 Oct 2015 09:49:34 -0500
Message-ID: <563231FE.1060904@pmcs.com>
References: <20151028215206.5323.84194.stgit@brunhilda>
 <20151028220441.5323.9715.stgit@brunhilda>
 <56322F1D.9060803@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33729 "EHLO
	mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbbJ2Otg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2015 10:49:36 -0400
Received: by oigi82 with SMTP id i82so3023540oig.0
        for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2015 07:49:36 -0700 (PDT)
In-Reply-To: <56322F1D.9060803@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: manoj@linux.vnet.ibm.com, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 10/29/2015 09:37 AM, Manoj Kumar wrote:
> Don: See comment below.
>
> - Manoj Kumar
>
> On 10/28/2015 5:04 PM, Don Brace wrote:
>> This function is no longer used.
>>
>> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
>> +#define HPSA_PERF_ERROR_BITS ((1 << DIRECT_LOOKUP_SHIFT) - 1)
>
> HPSA_PERF_ERROR_BITS seems to be only used in the function that was
> removed. Is there a reason to redefine this?
>
No, I'll remove it. Thanks!

