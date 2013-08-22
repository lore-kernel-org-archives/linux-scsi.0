From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [PATCH RESEND 3/3] zfcp: remove access control tables interface
 (keep sysfs files)
Date: Thu, 22 Aug 2013 18:40:56 +0200
Message-ID: <52163F18.2020109@linux.vnet.ibm.com>
References: <1377099366.2011.23.camel@dabdike.int.hansenpartnership.com> <1377186338-35344-1-git-send-email-maier@linux.vnet.ibm.com> <1377186338-35344-4-git-send-email-maier@linux.vnet.ibm.com> <1377189037.2009.14.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:43247 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab3HVQlC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Aug 2013 12:41:02 -0400
Received: from /spool/local
	by e06smtp17.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
	Thu, 22 Aug 2013 17:36:01 +0100
In-Reply-To: <1377189037.2009.14.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Martin Peschke <mpeschke@linux.vnet.ibm.com>

On 08/22/2013 06:30 PM, James Bottomley wrote:
> On Thu, 2013-08-22 at 17:45 +0200, Steffen Maier wrote:
>> From: Martin Peschke <mpeschke@linux.vnet.ibm.com>
>>
>> By popular demand, this patch brings back a couple of sysfs attribut=
es
>> removed by commit 663e0890e31cb85f0cca5ac1faaee0d2d52880b5
>> "[SCSI] zfcp: remove access control tables interface".
>> The content has been irrelevant for years, but the files must be
>> there forever for whatever user space tools that may rely on them.
>>
>> Since these files always return a constant value, a new stripped
>> down show-macro was required. Otherwise build warnings would have
>> been introduced.
>>
>> Signed-off-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>
>> Cc: stable@vger.kernel.org #3.11+
>
> If I'm sending this for 3.11-rc, this stable tag is unnecessary, righ=
t?
> It will go into 3.11 and you don't want it for 3.10.

Correct, it's a no-op, my bad.

--=20
Mit freundlichen Gr=FC=DFen / Kind regards
Steffen Maier

Linux on System z Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
