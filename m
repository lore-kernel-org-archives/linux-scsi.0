From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.0-test1 and qlogic 8.00.00b4 driver
Date: Tue, 29 Jul 2003 11:02:35 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030729110235.A26675@infradead.org>
References: <20030728220836.GA10845@thumper2.emsphone.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:56592 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S271385AbTG2KCg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jul 2003 06:02:36 -0400
Content-Disposition: inline
In-Reply-To: <20030728220836.GA10845@thumper2.emsphone.com>; from genanr@emsphone.com on Mon, Jul 28, 2003 at 05:08:37PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Andrew Ryan <genanr@emsphone.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Jul 28, 2003 at 05:08:37PM -0500, Andrew Ryan wrote:
> Linux is not seeing any devices attached to a CMD CRA-7280 san connected
> raid unit using kernel 2.6.0-test[12] and qlogic drive 8.00.00b4.  It works

It should be fine with plain -test1, with newer trees you need to add
a call to scsi_scan_host just after scsi_add_host.

