From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] add driver for DesignWare UFS Host Controller
Date: Thu, 7 Jan 2016 01:44:37 -0800
Message-ID: <20160107094437.GA11038@infradead.org>
References: <c6de799a23c6626b95ccdcb89ba0b2341b441fa0.1450293353.git.jpinto@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57239 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbcAGJoi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2016 04:44:38 -0500
Content-Disposition: inline
In-Reply-To: <c6de799a23c6626b95ccdcb89ba0b2341b441fa0.1450293353.git.jpinto@synopsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joao Pinto <Joao.Pinto@synopsys.com>, Yaniv Gardi <ygardi@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, CARLOS.PALMINHA@synopsys.com

> This driver patch includes a core driver and glue drivers for pci and platform
> for the DesignWare UFS Host IP.

Why doesn't this use the existing ufs core?  The architecture looks
completely backwards to me.

