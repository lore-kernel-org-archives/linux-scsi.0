From: Christoph Hellwig <hch@infradead.org>
Subject: Re: adaptec 2120S software under RedHat 8.0 and FC2
Date: Sun, 20 Mar 2005 09:12:51 +0000
Message-ID: <20050320091251.GB12000@infradead.org>
References: <60807403EABEB443939A5A7AA8A7458BED25F7@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from pentafluge.infradead.org ([213.146.154.40]:4575 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261666AbVCTJMz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Mar 2005 04:12:55 -0500
Content-Disposition: inline
In-Reply-To: <60807403EABEB443939A5A7AA8A7458BED25F7@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Mark Haverkamp <markh@osdl.org>, Ross Macintyre <raz@macs.hw.ac.uk>, linux-scsi <linux-scsi@vger.kernel.org>, Matt_Domsch@dell.com

On Thu, Mar 17, 2005 at 08:41:18AM -0500, Salyzyn, Mark wrote:
> We are pressuring our management application folks to switch to /sys as
> well, has not happened yet. In part because changes have to work for all
> tested releases and operating systems, our testing department only test
> distributions in the requirement documents, fixes are only approved if
> they affect current testing, certification testing requires a driver
> that can be fixed and not errata'd and thus typically can not be in-box,
> CONFIG_PROC_FS being on in all distributions and the need to keep the
> /proc interface alive to permit the current and legacy applications in
> test the ability to continue to function.

We're not going to add new procfs handler for scsi HBA drivers.

Unfortunately this problems shows once more that Adaptec managment doesn't
care the slightest bit for Linux and has the worst support of all RAID /
Storage vendors.  I can only advise OEMs and customers to stay far away
from Adaptec equipment if they want to use Linux.

