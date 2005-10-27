From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.14-rc5-mm1
Date: Thu, 27 Oct 2005 20:02:27 +0100
Message-ID: <20051027190227.GA16211@infradead.org>
References: <20051024014838.0dd491bb.akpm@osdl.org> <1130186927.6831.23.camel@localhost.localdomain> <20051024141646.6265c0da.akpm@osdl.org> <20051027152637.GC7889@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:51330 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751446AbVJ0TCd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Oct 2005 15:02:33 -0400
Content-Disposition: inline
In-Reply-To: <20051027152637.GC7889@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Andrew Morton <akpm@osdl.org>, Badari Pulavarty <pbadari@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Oct 27, 2005 at 08:26:37AM -0700, Andrew Vasquez wrote:
> qlogicfc attaches to both 2100 and 2200 ISPs.  It seems you're then
> trying to load qla2xxx driver along with the 2300 and 2200 firmware
> loader modules.  The pci_request_regions() call during 2200 probing
> fails.

Btw, now that devfs is gone and thus DaveM's host renumbering issues
are modd we'd like to kill qlogicfc.  I vaguely remember people complaing
qla2xxx made trouble on qla2100 hardware.  Andrew do you have any success
or error reports for that hardware?

