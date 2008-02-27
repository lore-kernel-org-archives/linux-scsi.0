From: "adam radford" <aradford@gmail.com>
Subject: Re: Performance problems with 3ware 9500S-4LP and 2.6.25-rc3
Date: Wed, 27 Feb 2008 12:06:08 -0800
Message-ID: <b1bc6a000802271206l3e99afedt64d5f7cc238365d6@mail.gmail.com>
References: <20080226174314.GA30767@skl-net.de>
	 <47C49B99.1060707@nets.rwth-aachen.de>
	 <20080227101154.GD30767@skl-net.de> <47C57327.6070901@cybernetics.com>
	 <20080227170528.GB29468@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759626AbYB0UGZ@vger.kernel.org>
In-Reply-To: <20080227170528.GB29468@skl-net.de>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: Tony Battersby <tonyb@cybernetics.com>, Arnd Hannemann <hannemann@nets.rwth-aachen.de>, =?ISO-8859-1?Q?Johannes_W=F6rner?= <johannes.woerner@tuebingen.mpg.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 27, 2008 at 9:05 AM, Andre Noll <maan@systemlinux.org> wrote:
> On 09:26, Tony Battersby wrote:
>  > > Thanks, this helped a lot. However, there does not seem to be a way
>  > > to make the system more responsive, which is really the problem we
>  > > are experiencing.

Andre,

Can you try turning down /sys/block/sdX/device/queue_depth to 16 and
see if that improves your responsiveness?

-Adam
