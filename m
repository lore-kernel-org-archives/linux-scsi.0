From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [RFC PATCH 2/2] lpfc: add target hooks
Date: Sat, 25 Apr 2015 00:50:17 +0200
Message-ID: <20150425005017.000078d5@localhost>
References: <20150412161740.00001d41@localhost>
	<552DAFE0.7050109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <552DAFE0.7050109@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, James Smart <james.smart@emulex.com>, Sebastian Herbszt <herbszt@gmx.de>
List-Id: linux-scsi@vger.kernel.org

Andy Grover wrote:
> On 04/12/2015 07:17 AM, Sebastian Herbszt wrote:
> > Add target hooks.
> >
> > Signed-off-by: Sebastian Herbszt <herbszt@gmx.de>
> 
> > +#ifdef LPFC_TARGET_MODE
> > +#include "lpfc_target_api.h"
> > +#include "lpfc_target_api_base.h"
> > +#endif
> 
> Hi, great to see new fabrics posted.

The code is actually not new. This is just yet another attempt to get
it upstream [1].

> There are a great many ifdefs like this. Are they strictly necessary?

None should be necessary. I left them in to allow an easy way to test
the code without impact on the initiator part of lpfc.

> Thanks -- Regards -- Andy

[1] http://www.spinics.net/lists/kernel/msg1060127.html

Sebastian
