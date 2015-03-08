From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Unifying the LIO and SCST target drivers
Date: Sun, 8 Mar 2015 09:09:20 -0700
Message-ID: <20150308160920.GA27635@infradead.org>
References: <54BCD00D.4080603@sandisk.com>
 <54E7112F.2080901@sandisk.com>
 <1424476807.1477.52.camel@haakon3.risingtidesystems.com>
 <54ED8B38.10904@sandisk.com>
 <1425074315.30923.74.camel@haakon3.risingtidesystems.com>
 <54F1ADAF.90808@sandisk.com>
 <1425279574.13530.53.camel@haakon3.risingtidesystems.com>
 <54F6DD3B.4030207@sandisk.com>
 <20150305132337.GA32341@infradead.org>
 <54F87F17.30207@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37490 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbbCHQJY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Mar 2015 12:09:24 -0400
Content-Disposition: inline
In-Reply-To: <54F87F17.30207@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Dr. Greg Wettstein" <greg@wind.enjellic.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

On Thu, Mar 05, 2015 at 05:06:47PM +0100, Bart Van Assche wrote:
> If we would do what Nic proposed - modify SCST such that it uses
> configfs instead of sysfs - then that would result in the removal of at
> least one SCST feature that is important to its users, namely automatic
> population of the configuration filesystem with hardware target port
> information. Apparently Nic does not want to convert LIO from configfs
> to sysfs. The reason I proposed to add empty transport_register_wwn()
> and transport_unregister_wwn() functions in the LIO core is because this
> allows LIO to keep using configfs and does not require to remove
> features from SCST.

I see your point, but I don't think it matters at this time.  If we had
all the core and driver code unified and the only thing preventing us
from going from two widely ued kernel targets to one was adding the
sysfs interface that would be an easy puill to swallow.  But there is a
lot of work to make that happen.  Just adding a stub that isn't used in
tree to support out of tree modules really isn't something we do, so
I have no problem with a plain outright rejection of it.
