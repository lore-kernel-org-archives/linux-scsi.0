From: Jes Sorensen <jes@wildopensource.com>
Subject: Re: [patch] qla1280 update for 2.6.1-mm4
Date: 19 Jan 2004 07:27:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <yq0znck6s4k.fsf@wildopensource.com>
References: <16395.51364.833229.536552@gargle.gargle.HOWL>
	<20040119121406.A32409@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:41658 "EHLO jaguar.mkp.net")
	by vger.kernel.org with ESMTP id S264598AbUASM1N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2004 07:27:13 -0500
In-Reply-To: <20040119121406.A32409@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, James.Bottomley@steeleye.com, jeremy@sgi.com

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

Christoph> On Mon, Jan 19, 2004 at 07:08:04AM -0500, Jes Sorensen
Christoph> wrote:
>> +#ifdef QLA_64BIT_PTR static int qla1280_64bit_start_scsi(struct
>> scsi_qla_host *, struct srb *); +#else static int
>> qla1280_32bit_start_scsi(struct scsi_qla_host *, struct srb *);
>> +#endif

Christoph> Shouldn't you just call both of those qla1280_start_scsi if
Christoph> only one of them is compiled at a time anyway?

I was actually thinking about merging them into one function since
they are 98% identical at the moment. However doing so requires more
testing and I'd like to get the obviously correct stuff out to the
users asap, including the big endian changes James posted.

So yes I agree, but thats qla1280 v3.25 material. Hopefully very soon
;-)

Cheers,
Jes


