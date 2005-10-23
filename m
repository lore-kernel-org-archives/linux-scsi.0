From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [patch 4/6] SCSI HCIL: kill all uses of spi_scan_target()
Date: Sat, 22 Oct 2005 19:56:44 -0600
Message-ID: <20051023015644.GD1605@parisc-linux.org>
References: <20051023013618.GA18201@havoc.gtf.org> <20051023014012.GD18279@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:58330 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1751385AbVJWB4o
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Oct 2005 21:56:44 -0400
Content-Disposition: inline
In-Reply-To: <20051023014012.GD18279@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

On Sat, Oct 22, 2005 at 09:40:12PM -0400, Jeff Garzik wrote:
> - export scsi_alloc_target().  eventually this will wind up
>   renamed to spi_alloc_target(), and become a wrapper around
>   scsi_alloc_target().

Should this be a _GPL export?  All current users are in transport
classes, so it feels a bit internal to me.

