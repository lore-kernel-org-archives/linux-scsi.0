From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] [ATTEND] Storage management (API &
 Library)
Date: Thu, 26 Jan 2012 15:56:16 -0500
Message-ID: <20120126205616.GA7633@infradead.org>
References: <4F19A981.4080502@redhat.com>
 <20120125174411.GB12620@infradead.org>
 <4F21BD3C.8050809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60217
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751971Ab2AZU4U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jan 2012 15:56:20 -0500
Content-Disposition: inline
In-Reply-To: <4F21BD3C.8050809@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Tony Asleson <tasleson@redhat.com>, lsf-pc@lists.linux-foundation.org, linux-scsi@vger.kernel.org

On Thu, Jan 26, 2012 at 12:53:16PM -0800, Andy Grover wrote:
> Nova is wrapping cmdline tools, and all the vendors interested so far
> are foss/cloudy.

I'm defintively not advocating that code, quite contrary.  Just pointing
out that it exists.

> This definitely shows others see a need for an API, but if we really
> want big storage vendor buy-in, then a better (C?/sockets?) API and
> working with non-foss code seems key.
> 
> Also, Nova code executes on the target machine, whereas libstoragemgmt
> is running on the mgmt node and the plugins are responsible for
> communication with the target node. (just wanted to point out another
> difference.)

As said, I'm not fond of the nova code, and I'm defintively not fond
of placing a storage management abstraction into highlevel "cloud"
management code.  But this just shows where the lack of a low-level
abstraction gets us.

