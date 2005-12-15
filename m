From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Move scsi_print_msg to SPI code
Date: Thu, 15 Dec 2005 13:58:56 -0700
Message-ID: <20051215205856.GA2361@parisc-linux.org>
References: <20051213165342.GM9286@parisc-linux.org> <439F13CD.8040602@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:48859 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1751086AbVLOU66
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Dec 2005 15:58:58 -0500
Content-Disposition: inline
In-Reply-To: <439F13CD.8040602@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Dec 13, 2005 at 01:32:45PM -0500, Jeff Garzik wrote:
> Strong ACK, though I think your change here should be split up:  the 
> patch to link against SPI should be separated from the scsi_print_msg() 
> change.

OK.  Here's a series of 5 patches which do this.  First I move
scsi_print_msg from constants.c to scsi_transport_spi.c, then I change its
name and convert all drivers to the new name.  Then I fix all its bugs ;-)
