From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [set5 PATCH 2/6] async: make async_synchronize_full() flush all
 work regardless of domain
Date: Sat, 23 Jun 2012 00:06:41 -0700
Message-ID: <CABE8wwtqEPkv-SeQU=CfUt45BrW2XWdCV6s3o6FhyZ3GbV9uPg@mail.gmail.com>
References: <20120622064657.21538.61711.stgit@dwillia2-linux.jf.intel.com>
	<20120622064707.21538.22198.stgit@dwillia2-linux.jf.intel.com>
	<alpine.DEB.2.02.1206222333050.1141@debianer>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga12.intel.com ([143.182.124.36]:62588 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750962Ab2FWHGp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Jun 2012 03:06:45 -0400
Received: by bkcjc3 with SMTP id jc3so1911742bkc.25
        for <linux-scsi@vger.kernel.org>; Sat, 23 Jun 2012 00:06:41 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.02.1206222333050.1141@debianer>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eldad Zack <eldad@fogrefinery.com>
Cc: linux-scsi@vger.kernel.org, Len Brown <len.brown@intel.com>, Meelis Roos <mroos@linux.ee>, linux-kernel@vger.kernel.org, James Bottomley <JBottomley@parallels.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Arjan van de Ven <arjan@linux.intel.com>

On Fri, Jun 22, 2012 at 2:40 PM, Eldad Zack <eldad@fogrefinery.com> wro=
te:
>
> On Thu, 21 Jun 2012, Dan Williams wrote:
>> In response to an async related regression James noted:
>>
>> =A0 "My theory is that this is an init problem: The assumption in a =
lot of
>> =A0 =A0our code is that async_synchronize_full() waits for everythin=
g ... even
>> =A0 =A0the domain specific async schedules, which isn't true."
>>
>> ...so make this assumption true.
>
> Hi Dan,
>
> I've applied the all 6 patches of this set.
> (HEAD 8874e812feb4926f4a51a82c4fca75c7daa05fc5 , Linus' tree)
>
> I've tested it on the same setup and everything runs fine, and I've
> seen no suspicious messages.
>
> If you'd like, I can test only patch #2 in isolation.

No, I think the testing you've done is enough.

> Tested-by: Eldad Zack <eldad@fogrefinery.com>

Much appreciated.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
