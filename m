From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 1/4] pm8001: clean bitmap management functions
Date: Mon, 07 Jul 2014 15:44:56 +0200
Message-ID: <53BAA458.905@redhat.com>
References: <1403795856-4300-1-git-send-email-thenzl@redhat.com> <CE2C58F938F4C44EA74FFF880BAA7E5E1CD7453F@BBYEXM02.pmc-sierra.internal> <20140703084531.GA17324@infradead.org> <CE2C58F938F4C44EA74FFF880BAA7E5E1CD75F18@BBYEXM02.pmc-sierra.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753452AbaGGNpY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Jul 2014 09:45:24 -0400
In-Reply-To: <CE2C58F938F4C44EA74FFF880BAA7E5E1CD75F18@BBYEXM02.pmc-sierra.internal>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>, Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Vasanthalakshmi Tharmarajan <Vasanthalakshmi.Tharmarajan@pmcs.com>, Viswas G <Viswas.G@pmcs.com>, "Jack Wang (xjtuwjp@gmail.com)" <xjtuwjp@gmail.com>

On 07/07/2014 03:12 PM, Suresh Thiagarajan wrote:
>
> On Thu, Jul 3, 2014 at 2:15 PM, Christoph Hellwig <hch@infradead.org> wrote:
>> Suresh,
>>
>> do you maintain pm8001 for pmcs now?  There have been lots of pm8001
>> patches on the list, many of them with reviews from various people
>> including Jack.  I'd be really greatful if someone could collect them
>> and resend them as a single coherent series.
>>
> Yes Christoph. Currently I am maintaining pm8001  from PMCS.
> I will collect all the patches since your last announcement on scsi patch queue tree 
> and resend as coherent series.

Suresh, 
could you also correct the "[PATCH 2/4] pm8001: honor return value" according
to your comments, or do you want me to send a new patch?
Tomas

>
>> Also it the MAINTAINERS information for pm8001 isn't uptodate anymore
>> please update it.
> Will send a patch to update the Maintainer's list.
>
> Thanks,
> Suresh Thiagarajan
>
>> Thanks,
>>         Christoph
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

