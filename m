From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Emulex] Ready for next round...
Date: Sun, 20 Jun 2004 14:35:43 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040620133543.GA4243@infradead.org>
References: <3356669BBE90C448AD4645C843E2BF28034F94D5@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:19929 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S265377AbUFTNfp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Jun 2004 09:35:45 -0400
Content-Disposition: inline
In-Reply-To: <3356669BBE90C448AD4645C843E2BF28034F94D5@xbl.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.Com>
Cc: Linux SCSI Reflector <linux-scsi@vger.kernel.org>


Can you please try to get rid of lpfc_disc_issue_rptlun()?  The scsi midlayer
already issues REPORT_LUNS on your behalf during scanning, and you should
be able to use it.  (IIRC we don't have midlayer help for the addressing mode
yet, but an addition of that would be welcome)
