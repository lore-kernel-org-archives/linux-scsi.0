From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: Re: [PATCH] scsi: bfa: bfad_attr.c: Optimization of the Code
Date: Sat, 7 Jun 2014 00:03:52 +0200
Message-ID: <CAFo99gaO1P2nZK2y_KMFJASB4_-y9fk9kOZhtsZFz3jJGbiKSQ@mail.gmail.com>
References: <1401905288-32642-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<5390147F.8070803@acm.org>
	<539017F0.1080503@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <539017F0.1080503@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi

Several have remarked in the other patch for strncpy I posted. That
there is a strlcpy that works exactly as one would like to strncpy was
done :)
And the return value is like for snprintf, but quite a lot faster!

So I submit patches based with it instead, and did a couple more
exchanges of snprintf to strlcpy.



Best regards
Rickard Strandqvist


2014-06-05 9:10 GMT+02:00 Bart Van Assche <bvanassche@acm.org>:
> On 06/05/14 08:55, Bart Van Assche wrote:
>> On 06/04/14 20:08, Rickard Strandqvist wrote:
>> This is ugly. Please use sprintf(buf, "%.*s\n", PAGE_SIZE - 1, str)
>> instead of strncpy() + strlen().
>
> (replying to my own e-mail)
>
> The above should of course have read "sprintf(buf, "%.*s\n", PAGE_SIZE -
> 2, str)" to avoid that the terminating '\0' triggers a buffer overflow.
>
> Bart.
