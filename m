From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] s390 (8/10): zfcp fixes.
Date: 16 Mar 2004 16:52:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1079473944.1804.21.camel@mulgrave>
References: <20040316135155.GI2785@mschwid3.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:62676 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261731AbUCPVwb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Mar 2004 16:52:31 -0500
In-Reply-To: <20040316135155.GI2785@mschwid3.boeblingen.de.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-03-16 at 08:51, Martin Schwidefsky wrote:
> +ZFCP_DEFINE_SCSI_ATTR(hba_id, "%s\n", zfcp_get_busid_by_unit(unit));
> +ZFCP_DEFINE_SCSI_ATTR(wwpn, "0x%016llx\n", unit->port->wwpn);
> +ZFCP_DEFINE_SCSI_ATTR(fcp_lun, "0x%016llx\n", unit->fcp_lun);

These attributes all properly belong in the fibrechannel transport
class, could you look at moving them over, please.

James


