From: Jes Sorensen <jes@wildopensource.com>
Subject: Re: [PATCH 2/3] qla1280: user pci_map_single
Date: 18 Feb 2005 04:48:00 -0500
Message-ID: <yq03bvunqr3.fsf@jaguar.mkp.net>
References: <20050210160026.GB8743@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from vanessarodrigues.com ([192.139.46.150]:57041 "EHLO
	jaguar.mkp.net") by vger.kernel.org with ESMTP id S261325AbVBRJsB
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Feb 2005 04:48:01 -0500
In-Reply-To: <20050210160026.GB8743@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

Christoph,

When pci_map_page was originally introduced it was meant to deprecate
pci_map_single, at least thats what my memory tells me.

If pci_map_single is suddenly recommended again we can change it back
to that, but I don't really see the gain.

Cheers,
Jes
