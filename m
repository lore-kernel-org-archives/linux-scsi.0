From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/8] qla2xxx: Add support for symbolic nodename FC transport attribute.
Date: Tue, 10 Oct 2006 10:30:50 +0100
Message-ID: <20061010093050.GC395@infradead.org>
References: <20061002185947.GF16536@andrew-vasquezs-computer.local> <11598156502784-git-send-email-andrew.vasquez@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:57012 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S965132AbWJJJav (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Oct 2006 05:30:51 -0400
Content-Disposition: inline
In-Reply-To: <11598156502784-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>

On Mon, Oct 02, 2006 at 12:00:44PM -0700, Andrew Vasquez wrote:
> Refactored original code from qla_gs.c:qla2x00_rsnn_nn().

Ok.  Should we also allow to change the name from userspace?

