From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH 2/2] scsi: reduce CONFIG_SCSI_CONSTANTS=y impact by 8k
Date: Tue, 06 Oct 2015 17:31:29 +0200
Message-ID: <87d1wsm2su.fsf@rasmusvillemoes.dk>
References: <20151004080217.GA22816@infradead.org>
	<1444037200-14684-1-git-send-email-linux@rasmusvillemoes.dk>
	<1444037200-14684-3-git-send-email-linux@rasmusvillemoes.dk>
	<56128527.1000703@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:36570 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbbJFPbc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Oct 2015 11:31:32 -0400
Received: by lbcao8 with SMTP id ao8so78672850lbc.3
        for <linux-scsi@vger.kernel.org>; Tue, 06 Oct 2015 08:31:31 -0700 (PDT)
In-Reply-To: <56128527.1000703@sandisk.com> (Bart Van Assche's message of
	"Mon, 5 Oct 2015 07:11:51 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Oct 05 2015, Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> On 10/05/15 02:26, Rasmus Villemoes wrote:
>>   struct error_info {
>>   	unsigned short code12;	/* 0x0302 looks better than 0x03,0x02 */
>> -	const char * text;
>> +	unsigned short size;
>>   };
>
> Had you considered to use the type uint16_t instead of unsigned short ?
>

Yes, but I thought I'd keep it consistent with the other member. AFAIK,
they're one and the same on all relevant arches. I actually think
spelling it u16 for both members would make sense (for the code because
it explicitly is meant to hold two bytes), but again I think that's
better done as a trivial follow-up patch, if we really want to change this.

Rasmus
