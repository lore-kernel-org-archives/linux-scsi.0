From: Vaughan Cao <vaughan.cao@oracle.com>
Subject: Re: [PATCH v2] sg: O_EXCL and other lock handling
Date: Sun, 03 Nov 2013 14:32:52 +0800
Message-ID: <5275EE14.2000701@oracle.com>
References: <52718713.7050906@interlog.com> <20131031155653.GA16944@infradead.org> <5272AD80.90203@interlog.com> <5273391C.2010705@oracle.com> <527542E3.7090809@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <527542E3.7090809@interlog.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dgilbert@interlog.com, Christoph Hellwig <hch@infradead.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-kernel <linux-kernel@vger.kernel.org>, =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
List-Id: linux-scsi@vger.kernel.org


On 2013=E5=B9=B411=E6=9C=8803=E6=97=A5 02:22, Douglas Gilbert wrote:
> On 13-11-01 01:16 AM, vaughan wrote:
>
> I do not follow the last point but that is not important.
>
>
> For reasons that I listed in a private post I think
> that my patch presented in this thread is closer to
> our goals than your patch (2013/6/17/319). Timing is
> important as well since we are approaching the lk 3.13
> merge window. Regressions are what will set us back.
>
Yes, I agree with you. My v2 patch lacks much consideration on=20
release/detach cases, which is a very significant issue we should=20
address along with o_excl bug.

Thanks,
Vaughan
