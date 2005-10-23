From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [patch 6/6] SCSI HCIL: misc cleanups
Date: Sat, 22 Oct 2005 20:03:13 -0600
Message-ID: <20051023020313.GF1605@parisc-linux.org>
References: <20051023013618.GA18201@havoc.gtf.org> <20051023014124.GF18279@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:985 "EHLO palinux.hppa")
	by vger.kernel.org with ESMTP id S1751391AbVJWCDO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Oct 2005 22:03:14 -0400
Content-Disposition: inline
In-Reply-To: <20051023014124.GF18279@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

On Sat, Oct 22, 2005 at 09:41:24PM -0400, Jeff Garzik wrote:
> - eliminate use of 'channel' and 'id' in starget_for_each_device()
> - unexport __scsi_device_lookup_by_target()
> - add some whitespace after '==', on one line

All looks good to me.
