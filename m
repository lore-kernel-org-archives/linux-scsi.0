From: Andrew Morton <akpm@digeo.com>
Subject: Re: scsi command slab allocation under memory pressure
Date: Mon, 3 Feb 2003 15:19:28 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030203151928.1f13c88a.akpm@digeo.com>
References: <20030129104731.A2811@beaverton.ibm.com>
	<3E382E2C.4030201@splentec.com>
	<20030129121117.A3389@beaverton.ibm.com>
	<20030130225738.1874c2e0.akpm@digeo.com>
	<1044020591.2002.16.camel@mulgrave>
	<20030131124412.086f2d1c.akpm@digeo.com>
	<20030203225550.GJ29516@redhat.com>
	<1044313513.1777.91.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from digeo-nav01.digeo.com (digeo-nav01.digeo.com [192.168.1.233])
	by packet.digeo.com (8.9.3+Sun/8.9.3) with SMTP id PAA21883
	for <linux-scsi@vger.kernel.org>; Mon, 3 Feb 2003 15:24:42 -0800 (PST)
In-Reply-To: <1044313513.1777.91.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: dledford@redhat.com, patmans@us.ibm.com, luben@splentec.com, linux-scsi@vger.kernel.org

James Bottomley <James.Bottomley@steeleye.com> wrote:
>
> Andrew, these patches are now in Linus' BK, so if you want to take a
> look and see how our loaded behaviour is, I'd be grateful.

Looks pretty straightforward.  Most of the allocations are GFP_KERNEL, which
is a good sign.

One could have designed it to support a pool of >1 command from the outset,
but it's unlikely to be necessary.

(linux-scsi@vger doesn't send messages to or from oneself to or from oneself.
 This upsets one's filing system.  Does this irritate otherselves as much as
this self?)
