From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [patch for 2.6.32? 1/3] scsi_lib.c: avoid calling
 scsi_device_put() from under ->host_lock
Date: Tue, 17 Nov 2009 19:26:52 -0500
Message-ID: <1258504012.4113.24.camel@mulgrave.site>
References: <200911172210.nAHMAAYJ014147@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56714 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756578AbZKRA1D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2009 19:27:03 -0500
In-Reply-To: <200911172210.nAHMAAYJ014147@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, strakh@ispras.ru, jens.axboe@oracle.com

On Tue, 2009-11-17 at 14:10 -0800, akpm@linux-foundation.org wrote:
> From: Alexander Strakh <strakh@ispras.ru>
> 
> Driver scsi_lib.c might sleep in atomic context, because it calls
> scsi_device_put under spin_lock_irqsave.

I thought I already gave an explanation why this is the wrong
analysis ... sorry on a plane and can't look it up.

James


