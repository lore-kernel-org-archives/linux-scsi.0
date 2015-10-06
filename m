From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH 1/2] scsi: move Additional Sense Codes to separate file
Date: Tue, 06 Oct 2015 17:27:57 +0200
Message-ID: <87h9m4m2yq.fsf@rasmusvillemoes.dk>
References: <20151004080217.GA22816@infradead.org>
	<1444037200-14684-1-git-send-email-linux@rasmusvillemoes.dk>
	<1444037200-14684-2-git-send-email-linux@rasmusvillemoes.dk>
	<56128398.8070908@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56128398.8070908@sandisk.com> (Bart Van Assche's message of
	"Mon, 5 Oct 2015 07:05:12 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 05 2015, Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> On 10/05/15 02:26, Rasmus Villemoes wrote:
>> -	{0x041A, "Logical unit not ready, start stop unit command in "
>> -	 "progress"},
>> -	{0x041B, "Logical unit not ready, sanitize in progress"},
>> -	{0x041C, "Logical unit not ready, additional power use not yet "
>> -	 "granted"},
>
> Please convert these multi-line strings into single line string
> constants such that users can look up these easily with grep.

I can certainly do that, but I'd prefer to do it in a separate patch. I
really want to keep this as mechanical as possible.

>> +
>> +SENSE_CODE(0, NULL)
>
> The above looks confusing to me. Please leave this out and add { 0,
> NULL } at the end of the additional[] array instead.

OK, I agree that that would have been cleaner. However, the sentinel
entry is removed in 2/2 (since we loop using ARRAY_SIZE instead of
checking for the sentinel). Let me know if you want me to resend the
1600 line monster anyway with this addressed.

Thanks,
Rasmus
