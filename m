From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/12]  qla2xxx: Update license.
Date: Sat, 15 Oct 2005 12:56:55 +0100
Message-ID: <20051015115654.GA24919@infradead.org>
References: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com> <20051013231614.27191.9897.sendpatchset@plap.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:27035 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750748AbVJOL5B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Oct 2005 07:57:01 -0400
Content-Disposition: inline
In-Reply-To: <20051013231614.27191.9897.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Oct 13, 2005 at 04:16:14PM -0700, Andrew Vasquez wrote:
> Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

NACK.  My contributions won't be relicensed under such an odd license.
The real fix is to allow userspace firmware loading for all HBA types
(as done in one of the later patches) and eventually remove the firmware
completely.

