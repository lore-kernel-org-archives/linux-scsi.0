From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] Generalize WWN to u64 interger conversions.
Date: Mon, 5 Sep 2005 13:26:54 +0100
Message-ID: <20050905122654.GA15791@infradead.org>
References: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com> <20050827020950.27275.51550.sendpatchset@plap.qlogic.com> <20050827104053.GA21026@infradead.org> <20050831221835.GI11577@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:7560 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751151AbVIEM06 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Sep 2005 08:26:58 -0400
Content-Disposition: inline
In-Reply-To: <20050831221835.GI11577@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, "Smart, James" <James.Smart@emulex.com>

On Wed, Aug 31, 2005 at 03:18:35PM -0700, Andrew Vasquez wrote:
> Ok, how about this generic patchset:
> 
> 1) add helper function to transport class
> 2) add support to qla2xxx
> 3) add support to lpfc -- I'll let James S. decide on
>    whether the union {} changes to lpfc_name are acceptable

looks very nice.

