From: Christoph Hellwig <hch@lst.de>
Subject: Re: Bugs in multipath scsi in 4.3-rc2
Date: Fri, 25 Sep 2015 17:18:02 +0200
Message-ID: <20150925151802.GB20282@lst.de>
References: <20150925121636.GC12540@fergus.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:45430 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756643AbbIYPSD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Sep 2015 11:18:03 -0400
Content-Disposition: inline
In-Reply-To: <20150925121636.GC12540@fergus.ozlabs.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Mackerras <paulus@ozlabs.org>
Cc: linux-scsi@vger.kernel.org

Hi Paul,

can you send the request_module fix as a proper signed off and described
patch?  I'll figure out what w can do about async scan vs request_module
in the meantime.
