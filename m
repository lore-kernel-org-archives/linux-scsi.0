From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH][RFC 2/23]: SCST core
Date: Wed, 10 Dec 2008 20:12:13 +0100
Message-ID: <20081210191213.GA15273@uranus.ravnborg.org>
References: <494009D7.4020602@vlnb.net> <49400ACD.3070502@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pfepa.post.tele.dk ([195.41.46.235]:39976 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbYLJTKv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Dec 2008 14:10:51 -0500
Content-Disposition: inline
In-Reply-To: <49400ACD.3070502@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Boaz Harrosh <bharrosh@panasas.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Bart Van Assche <bart.vanassche@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

On Wed, Dec 10, 2008 at 09:30:37PM +0300, Vladislav Bolkhovitin wrote:
> This patch contains SCST core code.
> 
> Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
> ---
>   drivers/scst/Kconfig         |  256 ++

Do not use "default n" - this is already the default value.

>   drivers/scst/Makefile        |   12
EXTRA_CFLAGS are deprecated in favour of ccflags-y


>   drivers/scst/scst_cdbprobe.h |  519 +++++
static const struct scst_sdbops scst_scsi_op_table[] 

This does not belong to a header file.


>   drivers/scst/scst_lib.c      | 3689 +++++++++++++++++++++++++++++++++++++
>   drivers/scst/scst_main.c     | 1919 +++++++++++++++++++
>   drivers/scst/scst_module.c   |   69
>   drivers/scst/scst_priv.h     |  513 +++++
>   drivers/scst/scst_targ.c     | 5458 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   8 files changed, 12435 insertions(+)

There was a lot af TRACE_ENTRY() / TRACE_EXIT() noise.
We should have proper tools for that by now (I hope).

We often ask for exported symbols to be documented - so one has
a slight idea of their purpose.

CONFIG_SCST_STRICT_SERIALIZING has bad impact on readability.
Could this be abstracted better?


I did not look into the source in details. Just a few sparse comments.

	Sam
