From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Proposal for new generic device API: dma_get_required_mask()
Date: 18 Jun 2004 09:19:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087568345.2135.10.camel@mulgrave>
References: <1087481331.2210.27.camel@mulgrave>
	<20040618055909.GA13007@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:27555 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265170AbUFROTK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jun 2004 10:19:10 -0400
In-Reply-To: <20040618055909.GA13007@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2004-06-18 at 00:59, Jeremy Higdon wrote:
> Sounds good.  But I'm curious why you make the driver call dma_set_mask()
> twice.

Basically so that dma_get_required_mask() returns a value that may be
related to the current mask.  If the device has a wierd mask setting
(say it has bits missing or something), the platform may want to return
something different to tune the required mask to be optimal.

James


