From: Jesse Barnes <jesse.barnes@intel.com>
Subject: Re: [PATCH] x86/pci: insert ioapic resource before assign
 unassigned resource for pci -v2
Date: Fri, 10 Jul 2009 13:03:44 -0700
Message-ID: <20090710130344.75f4d243@jbarnes-g45>
References: <20090630180300.GA9971@ldl.fc.hp.com>
	<4A4A5B01.9040200@kernel.org>
	<20090703225708.GA30664@ldl.fc.hp.com>
	<4A4FADDC.30606@kernel.org>
	<20090709185945.GG2613@ldl.fc.hp.com>
	<4A564263.5010305@kernel.org>
	<4A564634.1020708@kernel.org>
	<4A564990.3060202@kernel.org>
	<1247172044.3898.147.camel@mulgrave.site>
	<4A56641B.9050204@kernel.org>
	<4A576E04.9070004@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:1238 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302AbZGJUEG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jul 2009 16:04:06 -0400
In-Reply-To: <4A576E04.9070004@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, dann frazier <dannf@hp.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org, Stephen Frost <sfrost@snowman.net>

On Fri, 10 Jul 2009 09:36:20 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> 
> Stephen reported that his DL585 G2 need noapic after 2.6.22 (?)
> 
> Dann bisected
>   --------------------------------------------------------------------
>   commit 30a18d6c3f1e774de656ebd8ff219d53e2ba4029
>   Date:   Tue Feb 19 03:21:20 2008 -0800
> 
>       x86: multi pci root bus with different io resource range, on
>       64-bit
>   --------------------------------------------------------------------
> caused the problem.
> 

Applied to my for-linus tree, thanks Yinghai.

-- 
Jesse Barnes, Intel Open Source Technology Center
