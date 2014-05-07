From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] iscsi_ibft: search for broadcom specific ibft sign
Date: Wed, 07 May 2014 14:49:59 -0500
Message-ID: <536A8E67.7030805@cs.wisc.edu>
References: <1399453220-21663-1-git-send-email-vikas.chaudhary@qlogic.com> <20140507134757.GC12826@phenom.dumpdata.com> <1399489950.2227.63.camel@dabdike.int.hansenpartnership.com> <20140507192158.GA17806@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36938 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbaEGTu1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 May 2014 15:50:27 -0400
In-Reply-To: <20140507192158.GA17806@phenom.dumpdata.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: James Bottomley <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "giridhar.malavali@qlogic.com" <giridhar.malavali@qlogic.com>, "konrad@kernel.org" <konrad@kernel.org>, "vikas.chaudhary@qlogic.com" <vikas.chaudhary@qlogic.com>, "pjones@redhat.com" <pjones@redhat.com>, "iscsi-driver@qlogic.com" <iscsi-driver@qlogic.com>

On 05/07/2014 02:21 PM, Konrad Rzeszutek Wilk wrote:
> On Wed, May 07, 2014 at 07:12:31PM +0000, James Bottomley wrote:
>> On Wed, 2014-05-07 at 09:47 -0400, Konrad Rzeszutek Wilk wrote:
>>> On Wed, May 07, 2014 at 05:00:20AM -0400, vikas.chaudhary@qlogic.com wrote:
>>>> From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
>>>>
>>>> Broadcom iscsi offload firmware uses a non standard ibft sign of "BIFT".
>>>
>>> Why? If it uses the standard iBFT format why does it use
>>> a non-standard signature?
>>
>> This is useful as an academic exercise (and perhaps even a reminder to
>> broadcom not to do it again) but I don't think we can make it a show
>> stopper.  The boards have shipped with the non-standard signature, so we
>> have to work with them.
> 
> I agree as the train has left, but this got me thinking about these
> questions that I hope Qlogic folks could answer:
> 
>  - Mention what else is different - perhaps there are other entries that
>    are a bit different? Or maybe the are some non-standard ones added on?
> 
>  - How has this been tested? As in had all the fields been tested (so CHAP
>    on/off, extra ports, etc).
> 

This supports the same stuff as was added in the original commit for
that string:

140363500ddadad0c09cb512cc0c96a4d3efa053

It just was not carried over in the acpi specific table in commit
935a9fee51c945b8942be2d7b4bae069167b4886.
