From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PATCH] SCSI updates for 2.6.12
Date: Sat, 18 Jun 2005 15:16:36 +0100
Message-ID: <20050618141636.GA4112@infradead.org>
References: <1119103586.4984.5.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:52148 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262120AbVFROQl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Jun 2005 10:16:41 -0400
Content-Disposition: inline
In-Reply-To: <1119103586.4984.5.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

> Andrew Vasquez:
>   o qla2xxx: Pull-down scsi-host-addition to follow board initialization

Can we please put this one in 2.6.12.1?  qla2xxx breaks horribly in 2.6.12
because this one is missing.
