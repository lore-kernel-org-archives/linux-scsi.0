From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] New QStor SATA/RAID Driver for 2.6.9-rc2
Date: Wed, 15 Sep 2004 08:02:35 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040915080235.A17394@infradead.org>
References: <414711AC.5030200@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:45067 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261602AbUIOHCj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2004 03:02:39 -0400
Content-Disposition: inline
In-Reply-To: <414711AC.5030200@rtr.ca>; from lsml@rtr.ca on Tue, Sep 14, 2004 at 11:43:40AM -0400
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <lsml@rtr.ca>
Cc: linux-scsi@vger.kernel.org

Please fix all the style issues in here, aka

 - linebreaks after 80 characters
 - don't typedef structs unless they're used opaqueuely
 - please avoid C++-style comments even if C99 allows them
 - don't use "scsi.h", only headers from <scsi/*.h>, that also
   means getting rid of the Scsi_Foo typedefs
 - please don't include headers in other headers unless nessecary

I also don't want another SCSI->ATA translator in drivers/scsi, please find
some way to share codce with an existing one.

I'll do a real review once the driver is readable.
