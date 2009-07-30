From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] scsi: consistent use of __u8 in scsi/scsi.h
Date: Thu, 30 Jul 2009 12:45:18 +0300
Message-ID: <20090730094517.GC11381@redhat.com>
References: <20090729111114.GA15239@redhat.com> <1248875763.3900.1.camel@mulgrave.site> <4A705831.3010002@panasas.com> <20090729205626.GA3592@redhat.com> <4A71625C.8060707@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:44903 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbZG3JqW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Jul 2009 05:46:22 -0400
Content-Disposition: inline
In-Reply-To: <4A71625C.8060707@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 12:05:32PM +0300, Boaz Harrosh wrote:
> On 07/29/2009 11:56 PM, Michael S. Tsirkin wrote:
> > On Wed, Jul 29, 2009 at 05:09:53PM +0300, Boaz Harrosh wrote:
> >> TODO:
> >> * Fix up Kernel headers by complying to check_headers
> > 
> > This is accomplished by applying the following on top
> > of my previous patch:
> > 
> 
> This is not enough. The same should be done to the other 3 
> include/scsi headers I mentioned and export them.

Right. Well, that's easy enough, isn't it?

Subject: scsi: export scsi_ioctl.h and sg.h headers

glibc uses scsi/sg.h and scsi/scsi_ioctl.h, so we need to
export these headers.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/scsi/Kbuild |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/scsi/Kbuild b/include/scsi/Kbuild
index 33b2750..a61932c 100644
--- a/include/scsi/Kbuild
+++ b/include/scsi/Kbuild
@@ -1,3 +1,5 @@
+header-y += sg.h
+header-y += scsi_ioctl.h
 header-y += scsi.h
 header-y += scsi_netlink.h
 header-y += scsi_netlink_fc.h
-- 
1.6.2.5

