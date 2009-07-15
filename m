From: Mark Hounschell <dmarkh@cfl.rr.com>
Subject: Re: Scsi tape write protect status question
Date: Wed, 15 Jul 2009 06:52:14 -0400
Message-ID: <4A5DB4DE.1080302@cfl.rr.com>
References: <4A5CF2AE.2020001@compro.net> <3fb5199d5bcad051516f6874ac986f4f.squirrel@mail.compro.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:63828 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbZGOKwR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2009 06:52:17 -0400
In-Reply-To: <3fb5199d5bcad051516f6874ac986f4f.squirrel@mail.compro.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: markh@compro.net
Cc: linux-scsi@vger.kernel.org

Mark Hounschell wrote:
> Mark Hounschell wrote:
>> Sorry to bother you all with such an easy thing. I can't figure out how
>> the
>> kernel knows I have a write protected tape in a drive that I open via
>>
>> open("/dev/st0", O_RDWR, cf_flg, 0666)
> 
> Sorry for the typo
> 
> open("/dev/st0", O_RDWR, 0666)
> 
>> Using the sgio interface I can only sense a write protect status after
>> attempting to to a write.
>> How can one know this before doing a write op?
>>

Never mind, it's in the mode-sense data.
Mark

