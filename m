From: "'Christoph Hellwig'" <hch@lst.de>
Subject: Re: [PATCH scsi-misc 2/2] megaraid_sas: LSI Logic MegaRAID SAS RAID D river
Date: Mon, 29 Aug 2005 19:05:50 +0200
Message-ID: <20050829170550.GA21128@lst.de>
References: <0E3FA95632D6D047BA649F95DAB60E57060CD100@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:21965 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1750806AbVH2RGE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Aug 2005 13:06:04 -0400
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57060CD100@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, 'Christoph Hellwig' <hch@lst.de>, 'James Bottomley' <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@osdl.org>

Looks pretty good to me.  Small issues I've identified:

 - what do you need the hba_count attribute for?  This should be
   implementable in userspace pretty easily by iterating of all
   devices of the scsi_host class that are attached to the driver
 - the ->queuecommand cleanup patch I sent you a awhile ago doesn't
   seem to be applied
 - there's quite a lot of slightly odd formating, it would be nice
   if you could run the code through scripts/Lindent.

If you could sent out an unmangled patch (even as attachment or on
LSI's ftp side) I'd like to take another, closer look.

