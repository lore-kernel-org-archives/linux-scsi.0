From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2.5.59] sim710: cleanup/remove most cli()'s
Date: Tue, 4 Feb 2003 11:34:34 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030204113434.A31118@infradead.org>
References: <200302041123.06204@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200302041123.06204@bilbo.math.uni-mannheim.de>; from eike-kernel@sf-tec.de on Tue, Feb 04, 2003 at 11:23:06AM +0100
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-scsi@vger.kernel.org, Richard Hirst <rhirst@linuxcare.com>

> +#include <linux/stat.h>

I don't think this is actually needed.


And once you're at it. please make all host_template methods static,
remove the prototypes in sim710.h and initialize the driver template
directly in sim710.c instead of the pre-2.4 header magic.

