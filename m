From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH] scsi: logging_level: update bits description
Date: Wed, 11 Oct 2017 09:15:37 -0700
Message-ID: <0d26672b-e6ae-8e47-6d34-5d2e5a2d9795@infradead.org>
References: <7d747a9b-e0a0-0f64-f1f3-66338ec7bbea@infradead.org>
 <216D3DB1-C329-4B75-8210-822FF889C344@oracle.com>
 <ccfbbfed-b1e4-2db8-12a4-76d083f0a474@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:51006 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751350AbdJKQPl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Oct 2017 12:15:41 -0400
In-Reply-To: <ccfbbfed-b1e4-2db8-12a4-76d083f0a474@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>, Kyle Fortin <kyle.fortin@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>

On 10/11/17 06:18, Steffen Maier wrote:
> 
> On 10/10/2017 09:32 PM, Kyle Fortin wrote:
>> On Oct 10, 2017, at 3:05 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
>>> From: Randy Dunlap <rdunlap@infradead.org>
>>>
>>> Update the description of 'scsi_logging_level' from 8 4-bit nibbles
>>> to the (pre-git) reality of 10 3-bit 'nibbles'.
>>>
>>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>>> ---
>>> drivers/scsi/scsi_logging.h |    8 ++++----
>>> 1 file changed, 4 insertions(+), 4 deletions(-)
>>>
>>> --- lnx-414-rc3.orig/drivers/scsi/scsi_logging.h
>>> +++ lnx-414-rc3/drivers/scsi/scsi_logging.h
>>> @@ -3,10 +3,10 @@
>>>
>>>
>>> /*
>>> - * This defines the scsi logging feature.  It is a means by which the user
>>> - * can select how much information they get about various goings on, and it
>>> - * can be really useful for fault tracing.  The logging word is divided into
> 
> nit pick: Why reflow and thus "change" these 3 lines even though the content is the same?

Just to fit into max. of 80 characters per line. Changing it to only one long line
was weird.

>>> - * 8 nibbles, each of which describes a loglevel.  The division of things is
>>> + * This defines the scsi logging feature.  It is a means by which the user can
>>> + * select how much information they get about various goings on, and it can be
>>> + * really useful for fault tracing.  The logging word is divided into 10 3-bit
>>> + * 'nibbles', each of which describes a loglevel.  The division of things is
>>
>> I think ‘bitfields' is more appropriate than ‘nibbles’ (a 4-bit construct in compute).
> 
> +1

OK.

>>>   * somewhat arbitrary, and the division of the word could be changed if it
>>>   * were really needed for any reason.  The numbers below are the only place
>>>   * where these are specified.  For a first go-around, 3 bits is more than
>>
>> Reviewed-by: Kyle Fortin <kyle.fortin@oracle.com>
> 
> Reviewed-by: Steffen Maier <maier@linux.vnet.ibm.com>
> 


-- 
~Randy
