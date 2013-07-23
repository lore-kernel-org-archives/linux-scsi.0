From: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] mvsas: fix unaligned-access kernel panic under heavy
 disk testing
Date: Tue, 23 Jul 2013 17:17:14 -0400
Message-ID: <51EEF2DA.3070903@tilera.com>
References: <201307232053.r6NKrkOh032171@farm-0012.internal.tilera.com> <1374613204.2290.49.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1374613204.2290.49.camel@dabdike>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jianpeng Ma <majianpeng@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Xi Wang <xi.wang@gmail.com>, Xiangliang Yu <yuxiangl@marvell.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 7/23/2013 5:00 PM, James Bottomley wrote:
> On Tue, 2013-07-23 at 16:50 -0400, Chris Metcalf wrote:
>> > The slot->response value may not be aligned, so should be read
>> > using the appropriate kernel "unaligned" accessor.
> Hm, institutional memory re-presenting the wrong patch?  However, I am
> reminded to push the right one in spite of no ack from marvell.

You may be right; the original author of that patch is not me, but someone else here at Tilera.

That said, the version I pushed is effectively the version we have in the tip of our tree, so if we've ended up carrying the wrong patch, that's bad!  Let me know what the right patch is that you have - thanks.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com
