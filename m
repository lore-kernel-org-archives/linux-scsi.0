From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] [ANNOUNCE] multipath-tools-0.4.1
Date: Thu, 23 Dec 2004 19:17:54 +0000
Message-ID: <20041223191754.GA30058@infradead.org>
References: <41EBA11203419D4CA8EB4C6140D8B401010212E4@AVEXCH01.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:12238 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261239AbULWTSA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Dec 2004 14:18:00 -0500
Content-Disposition: inline
In-Reply-To: <41EBA11203419D4CA8EB4C6140D8B401010212E4@AVEXCH01.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Duane Grigsby <duane.grigsby@qlogic.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Caushik, Ramesh" <ramesh.caushik@intel.com>, device-mapper development <dm-devel@redhat.com>, linux-raid@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Thu, Dec 23, 2004 at 11:08:36AM -0800, Duane Grigsby wrote:
> The problem is we have to support the distros which do not have support for fc_transport, so I would suggest you use but the mainline driver as well.

I think that's those distributions problems.  The FC and RHEL4 kernels
are pretty uptodate, and SLES9 has partial fc_transport support since
SP1.  But they use the broken qlogic drivers instead of the mainline ones
anyway.

