From: Jes Sorensen <jes@wildopensource.com>
Subject: Re: [PATCH 2/3] qla1280: user pci_map_single
Date: 25 Feb 2005 08:48:57 -0500
Message-ID: <yq0d5uoeomu.fsf@jaguar.mkp.net>
References: <20050210160026.GB8743@lst.de> <yq03bvunqr3.fsf@jaguar.mkp.net>
	<20050218102131.GA2941@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from vanessarodrigues.com ([192.139.46.150]:61064 "EHLO
	jaguar.mkp.net") by vger.kernel.org with ESMTP id S262699AbVBYNs7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2005 08:48:59 -0500
In-Reply-To: <20050218102131.GA2941@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> On Fri, Feb 18, 2005 at 04:48:00AM -0500, Jes Sorensen
Christoph> wrote:
>> Christoph,
>> 
>> When pci_map_page was originally introduced it was meant to
>> deprecate pci_map_single, at least thats what my memory tells me.

Christoph> No, it's for rather different uses.  pci_map_page would be
Christoph> nice to get rid of in favour of pci_map_sg OTOH..

I guess things have changed a bit since it was introduced. Anyway go
ahead and push the patch.

Cheers,
Jes
