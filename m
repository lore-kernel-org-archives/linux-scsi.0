From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: MPT2SAS boot fail... due to silently loosing the driver
Date: Mon, 30 Nov 2015 09:27:32 -0800
Message-ID: <1448904452.2204.24.camel@HansenPartnership.com>
References: <20151123124621.GF7520@twins.programming.kicks-ass.net>
	 <yq1wpt7li62.fsf@sermon.lab.mkp.net> <20151126104823.GA8745@gmail.com>
	 <yq14mg3iesi.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq14mg3iesi.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Sreekanth.Reddy@avagotech.com, hch@lst.de, hare@suse.de, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

[cc to linux-scsi added]
On Mon, 2015-11-30 at 12:21 -0500, Martin K. Petersen wrote:
> >>>>> "Ingo" == Ingo Molnar <mingo@kernel.org> writes:
> 
> Ingo> So you need to make it interactive, with a short help text that
> Ingo> explains to users that this is legacy option only, and that they
> Ingo> should enable the MPT3SAS option if they want to configure things
> Ingo> manually.
> 
> +config SCSI_MPT2SAS
> +	tristate "Legacy MPT2SAS config option"
> +	default n
> +	select SCSI_MPT3SAS
> +	---help---
> +	Dummy config option for backwards compatiblity: configure the MPT3SAS 
> +	driver instead.
> 
> That's fine with me.
> 
> Sreekanth/Christoph/James: Any objections?

Looks OK, we probably need a removal timeframe for it as well.  What
about removal in 4.6?

James
