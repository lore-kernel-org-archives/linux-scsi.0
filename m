From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] x86/pci: insert ioapic resource before assign unassigned
 resource for pci -v2
Date: Fri, 10 Jul 2009 14:27:09 -0700 (PDT)
Message-ID: <alpine.LFD.2.01.0907101426490.3352@localhost.localdomain>
References: <20090630180300.GA9971@ldl.fc.hp.com>  <4A4A5B01.9040200@kernel.org> <20090703225708.GA30664@ldl.fc.hp.com>  <4A4FADDC.30606@kernel.org> <20090709185945.GG2613@ldl.fc.hp.com>  <4A564263.5010305@kernel.org> <4A564634.1020708@kernel.org>
 <4A564990.3060202@kernel.org> <1247172044.3898.147.camel@mulgrave.site> <4A56641B.9050204@kernel.org> <4A576E04.9070004@kernel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757124AbZGJV24@vger.kernel.org>
In-Reply-To: <4A576E04.9070004@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>, dann frazier <dannf@hp.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org, Stephen Frost <sfrost@snowman.net>
List-Id: linux-scsi@vger.kernel.org



On Fri, 10 Jul 2009, Yinghai Lu wrote:
> 
> solution is trying to insert ioapic_resource early a little bit.
> 
> v2: update comments

Ack, looks sane to me.

		Linus
