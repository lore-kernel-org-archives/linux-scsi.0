From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH ] mptsas: support link error attributes[2 round] - and phy_reset attributes
Date: Wed, 19 Oct 2005 12:19:18 +0100
Message-ID: <20051019111918.GA30333@infradead.org>
References: <91888D455306F94EBD4D168954A9457C048719B2@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:29396 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S964801AbVJSLTV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Oct 2005 07:19:21 -0400
Content-Disposition: inline
In-Reply-To: <91888D455306F94EBD4D168954A9457C048719B2@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux scsi <linux-scsi@vger.kernel.org>

On Tue, Oct 18, 2005 at 07:57:15AM -0600, Moore, Eric Dean wrote:
> For the link/phy reset support, were you planning to submit
> seperate patch's for this, or were you wanting me to handle that?

I plan to add some additional bits (e.g. move the phy on hba vs expander
bit to the transport class) and submit the split patches.  If you already
have split patches feel free to send them out and I'll submit incremental
patches ontop.

