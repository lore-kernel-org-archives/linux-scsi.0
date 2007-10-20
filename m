From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: oops in lbmIODone, fails to boot [Re: 2.6.23-mm1]
Date: Fri, 19 Oct 2007 22:34:40 -0700
Message-ID: <20071019223440.3bf845ef.akpm@linux-foundation.org>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
	<20071020045753.GA4660@inferi.kami.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55436 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751845AbXJTFe5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Oct 2007 01:34:57 -0400
In-Reply-To: <20071020045753.GA4660@inferi.kami.home>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mattia Dongili <malattia@linux.it>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Dave Kleikamp <shaggy@austin.ibm.com>

On Sat, 20 Oct 2007 13:57:54 +0900 Mattia Dongili <malattia@linux.it> wrote:

> On Thu, Oct 11, 2007 at 09:31:26PM -0700, Andrew Morton wrote:
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/2.6.23-mm1/
> 
> Hey there!!
> fails to boot here with this friendly oops:
> http://oioio.altervista.org/linux/dsc01702.jpg
> 
> .config: http://oioio.altervista.org/linux/config-2.6.23-mm1-1
> 
> 2.6.23-rc8-mm2 booted ok but had other problems I haven't reported yet
> (no s2ram with mysql running and some net WARNING).
> Let's see if .23-mm1 still has those first.
> 
> I'm adding Cc: linux-scsi
> 
> PS: I'll hardly be able to bisect in the next days... :P

That looks like a Jens and Dave production to me.
