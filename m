From: "Mark Hounschell" <markh@compro.net>
Subject: Re: Scsi tape write protect status question
Date: Tue, 14 Jul 2009 17:23:01 -0400 (EDT)
Message-ID: <3fb5199d5bcad051516f6874ac986f4f.squirrel@mail.compro.net>
References: <4A5CF2AE.2020001@compro.net>
Reply-To: markh@compro.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.compro.net ([216.54.166.4]:44290 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756101AbZGNVXG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jul 2009 17:23:06 -0400
In-Reply-To: <4A5CF2AE.2020001@compro.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: markh@compro.net
Cc: linux-scsi@vger.kernel.org, Mark Hounschell <dmarkh@cfl.rr.com>

Mark Hounschell wrote:
> Sorry to bother you all with such an easy thing. I can't figure out how
> the
> kernel knows I have a write protected tape in a drive that I open via
>
> open("/dev/st0", O_RDWR, cf_flg, 0666)

Sorry for the typo

open("/dev/st0", O_RDWR, 0666)

>
> Using the sgio interface I can only sense a write protect status after
> attempting to to a write.
> How can one know this before doing a write op?
>
> Thanks in advance
> Mark
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


