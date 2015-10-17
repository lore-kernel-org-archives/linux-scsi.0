From: Rasmus Villemoes <rv@rasmusvillemoes.dk>
Subject: Re: [PATCH 1/2] scsi: move Additional Sense Codes to separate file
Date: Sun, 18 Oct 2015 00:12:31 +0200
Message-ID: <8737x9nnzk.fsf@rasmusvillemoes.dk>
References: <20151004080217.GA22816@infradead.org>
	<1444037200-14684-1-git-send-email-linux@rasmusvillemoes.dk>
	<1444037200-14684-2-git-send-email-linux@rasmusvillemoes.dk>
	<56128398.8070908@sandisk.com> <87h9m4m2yq.fsf@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33919 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbbJQWMe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 17 Oct 2015 18:12:34 -0400
Received: by wikq8 with SMTP id q8so5038354wik.1
        for <linux-scsi@vger.kernel.org>; Sat, 17 Oct 2015 15:12:33 -0700 (PDT)
In-Reply-To: <87h9m4m2yq.fsf@rasmusvillemoes.dk> (Rasmus Villemoes's message
	of "Tue, 06 Oct 2015 17:27:57 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Oct 06 2015, Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:

> On Mon, Oct 05 2015, Bart Van Assche <bart.vanassche@sandisk.com> wrote:
>
>> On 10/05/15 02:26, Rasmus Villemoes wrote:
>>> -	{0x041A, "Logical unit not ready, start stop unit command in "
>>> -	 "progress"},
>>> -	{0x041B, "Logical unit not ready, sanitize in progress"},
>>> -	{0x041C, "Logical unit not ready, additional power use not yet "
>>> -	 "granted"},
>>
>> Please convert these multi-line strings into single line string
>> constants such that users can look up these easily with grep.
>
> I can certainly do that, but I'd prefer to do it in a separate patch. I
> really want to keep this as mechanical as possible.
>
>>> +
>>> +SENSE_CODE(0, NULL)
>>
>> The above looks confusing to me. Please leave this out and add { 0,
>> NULL } at the end of the additional[] array instead.
>
> OK, I agree that that would have been cleaner. However, the sentinel
> entry is removed in 2/2 (since we loop using ARRAY_SIZE instead of
> checking for the sentinel). Let me know if you want me to resend the
> 1600 line monster anyway with this addressed.

Should I resend, or can these be picked up as-is? I can easily send a
3/2 making the strings more greppable.

Thanks,
Rasmus
