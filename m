From: Christoph Hellwig <hch@infradead.org>
Subject: Re: adaptec 2120S software under RedHat 8.0 and FC2
Date: Mon, 28 Mar 2005 22:57:43 +0100
Message-ID: <20050328215743.GA14148@infradead.org>
References: <60807403EABEB443939A5A7AA8A7458BED3211@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:4759 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262083AbVC1V5r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Mar 2005 16:57:47 -0500
Content-Disposition: inline
In-Reply-To: <60807403EABEB443939A5A7AA8A7458BED3211@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Ross Macintyre <raz@macs.hw.ac.uk>, Mark Haverkamp <markh@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>, matt_domsch@dell.com

> > note that if adaptec simply opensourced their managment tools we
> wouldn't
> > have this problem at all. I wonder why Adaptec did that for the old
> > i2o-based controllers but not aacraid.  
> 
> Oh yes, that, worked hard on the powers-that-be to permit this. Could
> not release a substantial majority of it because it would violate
> licensed libraries (Zinc, being one of them, I am sorry to admit). So we
> release the engine and the raidutil. No logger, no remote communication
> engine, no GUI and no browser engine either. It was the best we could
> do.

Which is more than enough.

> Once released, and under a BSD license, the open source community failed
> to contribute one change to the sources. All it did was permit the tools
> to be packaged, archived and to continue in-perpetuity when
> compatibility libraries failed to work on newer installations.

Which is exactly what we need.  We don't need gazillions of new features
but code that can be carried forward easily and fixed where nessecary.

