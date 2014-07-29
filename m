From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 RESEND 17/23] pm8001: Fix invalid return when
 request_irq() failed
Date: Tue, 29 Jul 2014 07:24:03 -0700
Message-ID: <20140729142403.GA13589@infradead.org>
References: <cover.1405533479.git.agordeev@redhat.com>
 <5ecd9b80f705545c3dc85b2a4ae63a8ac3df8105.1405533479.git.agordeev@redhat.com>
 <53D79DE2.9000702@redhat.com>
 <20140729132020.GA7714@infradead.org>
 <53D7A62D.2090709@redhat.com>
 <20140729135641.GA14378@infradead.org>
 <20140729141544.GA18029@dhcp-26-207.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44550 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbaG2OYH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jul 2014 10:24:07 -0400
Content-Disposition: inline
In-Reply-To: <20140729141544.GA18029@dhcp-26-207.brq.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Tomas Henzl <thenzl@redhat.com>, linux-kernel@vger.kernel.org, xjtuwjp@gmail.com, lindar_liu@usish.com, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>

On Tue, Jul 29, 2014 at 04:15:45PM +0200, Alexander Gordeev wrote:
> Hmm.. 18/23 applies with a minor fuzz against
> git://git.infradead.org/users/hch/scsi-queue.git drivers-for-3.17

Okay, it was just git-am being goofy then.  I'll take care of it.

