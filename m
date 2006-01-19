From: Chase Venters <chase.venters@clientec.com>
Subject: Re: scsi cmd slab leak? (Was Re: [ck] Anyone been having OOM killer problems lately?)
Date: Thu, 19 Jan 2006 12:22:08 -0600
Message-ID: <200601191222.30441.chase.venters@clientec.com>
References: <200601181951.16708.chase.venters@clientec.com> <200601190334.25712.chase.venters@clientec.com> <43CFD6D6.2040700@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay01.pair.com ([209.68.5.15]:7685 "HELO relay01.pair.com")
	by vger.kernel.org with SMTP id S1161155AbWASSWg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jan 2006 13:22:36 -0500
In-Reply-To: <43CFD6D6.2040700@gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "scientica (GMail)" <scientica@gmail.com>
Cc: Con Kolivas <kernel@kolivas.org>, ck@vds.kolivas.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thursday 19 January 2006 12:13, scientica (GMail) wrote:
> Just out of curiosity, what's the slab? and what is the expected size
> of it? I just checked mine and it seems to eat some 304596 kB
> (2.6.14-ck4, soon 68d uptime). The only problems I've had recently is
> firefox crashing more than it should (but it could simply be me having
> a billion or so windows and tabs open, and it's the
> mozilla-firefox-bin-1.5-r2 from portage which is masked ~amd64, so
> it's probably just buggy - it dies with a segfault after beeing stuck
> at 100% CPU for a while, cant see any OOM-messages anywhere), other
> than that I've been able to both emerge stuff (nice'd though),
> download stuff and burn backups DVD's with out problems -
> simultaneously - and the system was still responsive :)

The slab layer in the kernel is an algorithm that attempts to reserve a sane 
amount of memory for a given highly-used data structure in the kernel. By 
using the slab layer to keep memory reserved and ready, performance-critical 
sections of the kernel code (say, code that receives a packet) doesn't have 
to stop and succeed an allocation before continuing.

Cheers,
Chase
