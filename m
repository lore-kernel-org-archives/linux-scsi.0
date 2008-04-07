From: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: scsi: fix sense_slab/bio swapping livelock
Date: Mon, 7 Apr 2008 13:17:54 +0300
Message-ID: <84144f020804070317j4af69036q9801c288ba9ecac4@mail.gmail.com>
References: <200804062359.m36Nx3lA016774@hera.kernel.org>
	 <47F9EAD9.3060103@panasas.com>
	 <Pine.LNX.4.64.0804071248110.30814@sbz-30.cs.Helsinki.FI>
	 <47F9F266.4090107@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.239]:39727 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541AbYDGKR4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Apr 2008 06:17:56 -0400
Received: by wx-out-0506.google.com with SMTP id h31so1326462wxd.4
        for <linux-scsi@vger.kernel.org>; Mon, 07 Apr 2008 03:17:55 -0700 (PDT)
In-Reply-To: <47F9F266.4090107@panasas.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Hugh Dickins <hugh@veritas.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>, Christoph Lameter <clameter@sgi.com>, Peter Zijlstra <a.p.ziljstra@chello.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>, mpm@selenic.com, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

Hi Boaz,

On Mon, Apr 7, 2008 at 1:07 PM, Boaz Harrosh <bharrosh@panasas.com> wrote:
>  Please forgive my ignorance, but what is then the difference between kmem_cache_alloc()
>  and kmalloc?

Constructors, user-defined alignment, and tighter object packing.

On Mon, Apr 7, 2008 at 1:07 PM, Boaz Harrosh <bharrosh@panasas.com> wrote:
>  would you not agree that sometimes we want to override that sharing of SLOBs?

To be honest, I really don't quite understand your use-case. But as
far as I can tell, it hasn't never been explicitly guaranteed and most
certainly has not been true since the merging of SLOB and more
recently SLUB.

                Pekka
