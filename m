From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] minimal SAS transport class
Date: Mon, 15 Aug 2005 16:35:21 +0200
Message-ID: <1124116522.3228.42.camel@laptopd505.fenrus.org>
References: <20050815135537.GB19426@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:6827 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S964792AbVHOOfq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 10:35:46 -0400
In-Reply-To: <20050815135537.GB19426@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, andrew.patterson@hp.com, Eric.Moore@lsil.com, ltuikov@yahoo.com, jejb@steeleye.com

On Mon, 2005-08-15 at 15:55 +0200, Christoph Hellwig wrote:
> +EXPORT_SYMBOL(sas_add_target);

should these exports be _GPL? After all they're very much linux specific
functionality...



