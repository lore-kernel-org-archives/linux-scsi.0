From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH 2/8] qla2xxx: Add support for symbolic nodename FC transport attribute.
Date: Thu, 12 Oct 2006 09:37:44 -0700
Message-ID: <20061012163744.GE3638@andrew-vasquezs-computer.local>
References: <20061002185947.GF16536@andrew-vasquezs-computer.local> <11598156502784-git-send-email-andrew.vasquez@qlogic.com> <20061010093050.GC395@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:40125 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S932678AbWJLQhq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Oct 2006 12:37:46 -0400
Content-Disposition: inline
In-Reply-To: <20061010093050.GC395@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>

On Tue, 10 Oct 2006, Christoph Hellwig wrote:

> On Mon, Oct 02, 2006 at 12:00:44PM -0700, Andrew Vasquez wrote:
> > Refactored original code from qla_gs.c:qla2x00_rsnn_nn().
> 
> Ok.  Should we also allow to change the name from userspace?

Maybe...  FC-GS provides for no restrictions on format or content.
Most initiator/target implementations I've seen have common items such
as Manufacturer, Part ID, and driver/firmware version in the field.
It might be useful (at least from a initiator perspective) within a
virtualized environment to allow for information to be added to the
SNN field, e.g. container id, DOM #, or some Virtual OS metadata.

Mike, James, Eric, any thoughts?
