From: Mark Lord <kernel@teksavvy.com>
Subject: Re: NEC ND-4550A problems reading DVD-R
Date: Tue, 01 Mar 2011 08:48:26 -0500
Message-ID: <4D6CF92A.4020105@teksavvy.com>
References: <m339n7g7tw.fsf@intrepid.localdomain> <20110301080153.GA26074@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110301080153.GA26074@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11-03-01 03:01 AM, Tejun Heo wrote:
..
> I think that's determined by drivers/scsi/sr.h::SR_TIMEOUT which is
> hardcoded to be 30 seconds.  Maybe it's better to move it to use the
> block parameter.  Anyways, the drive actually takes longer than 30secs
> to recognize the media?

That slow behaviour is not uncommon, especially as drives struggle
to recognize various forms of copy-protected media (DVD-Video).
A longer default, or tuneable timeout, would help.

Cheers
