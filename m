From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] killing the AMD53C974 and mac_NCR5380 drivers
Date: Sun, 1 Feb 2004 18:05:46 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040201170546.GA15760@lst.de>
References: <20040201160801.GA15020@lst.de> <20040201170240.31968.qmail@web42002.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:14765 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S265375AbUBARFs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Feb 2004 12:05:48 -0500
Content-Disposition: inline
In-Reply-To: <20040201170240.31968.qmail@web42002.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: Alexander Schunk <alexander_schunk@yahoo.de>
Cc: linux-scsi@vger.kernel.org

On Sun, Feb 01, 2004 at 06:02:40PM +0100, Alexander Schunk wrote:
> Hi,
>  
> well, if this AMD is related to i686 computers, yes. What exactly is this good for??

Hehe, AMD makes/made more chips then just CPUs.  This is a scsi
controller, but I haven't seen people using it on non-x86 machines yet,
but it's just a simple PCI card or sometimes even an onboard chip IIRC.

Question answered?

