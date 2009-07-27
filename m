From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Don't export scsi kernel variables in userspace
	headers.
Date: Mon, 27 Jul 2009 03:44:18 -0400
Message-ID: <20090727074418.GA14765@infradead.org>
References: <20090725021026.GA6942@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59395 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbZG0HoS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2009 03:44:18 -0400
Content-Disposition: inline
In-Reply-To: <20090725021026.GA6942@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Fri, Jul 24, 2009 at 10:10:26PM -0400, Dave Jones wrote:
> Found with make headers_check
> 
> /usr/include/scsi/scsi.h:159: userspace cannot call function or variable defined in the kernel
> /usr/include/scsi/scsi.h:285: userspace cannot call function or variable defined in the kernel

The headers shouldn't be exported at all because scsi/ headers are
exported from glibc.

