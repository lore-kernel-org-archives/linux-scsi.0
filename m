From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: stex driver panic in kernel 2.6.23
Date: Wed, 24 Oct 2007 12:17:14 -0700
Message-ID: <20071024121714.149b10c7.akpm@linux-foundation.org>
References: <NONAMEWzsLqIfQdmEB40000023f@nonamew.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35992 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753036AbXJXTSb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Oct 2007 15:18:31 -0400
In-Reply-To: <NONAMEWzsLqIfQdmEB40000023f@nonamew.ptu.promise.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ed Lin <ed.lin@promise.com>
Cc: "james.Bottomley" <james.Bottomley@SteelEye.com>, "jens.axboe" <jens.axboe@oracle.com>, jeff <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 24 Oct 2007 11:59:30 -0700 "Ed Lin" <ed.lin@promise.com> wrote:

> The shared tag issue was not fixed yet. Kernel panic
> happened while running I/O test in kernel 2.6.23
> (information attached). After applying the patch I posted
> (or the version James modified), panic disappeared.
> Switch back to standard kernel, panic again.

Did either of those patches get merged in 2.6.24-rc1?
