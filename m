From: Christoph Hellwig <hch@infradead.org>
Subject: Re: I2O enhancement for Adaptec management software
Date: Mon, 5 Apr 2004 11:05:24 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040405110524.A3987@infradead.org>
References: <40712A47.4090903@shadowconnect.com> <1081159378.4679.1.camel@laptop.fenrus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:24585 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261678AbUDEKF1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Apr 2004 06:05:27 -0400
Content-Disposition: inline
In-Reply-To: <1081159378.4679.1.camel@laptop.fenrus.com>; from arjanv@redhat.com on Mon, Apr 05, 2004 at 12:02:59PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjanv@redhat.com>
Cc: Markus Lidel <Markus.Lidel@shadowconnect.com>, linux-scsi@vger.kernel.org

On Mon, Apr 05, 2004 at 12:02:59PM +0200, Arjan van de Ven wrote:
> is there a convincing argument why this can't use the SG_IO mechanism
> instead of a device private ioctl ?

Yes.  These are i2o commands, not scsi commands.

