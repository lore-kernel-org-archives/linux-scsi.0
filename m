From: Davidlohr Bueso <dave@gnu.org>
Subject: Re: [PATCH 00/20] SCSI: No longer use Scsi_Cmd typedef
Date: Tue, 10 Nov 2009 07:11:24 -0500
Message-ID: <20091110121124.GA18938@fencepost.gnu.org>
References: <1257711411.4759.105.camel@dbueso-pc> <4AF7CDE7.8030008@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([140.186.70.10]:44537 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbZKJMLT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2009 07:11:19 -0500
Content-Disposition: inline
In-Reply-To: <4AF7CDE7.8030008@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Nov 09, 2009 at 10:08:07AM +0200, Boaz Harrosh wrote:
> On 11/08/2009 10:16 PM, Davidlohr Bueso wrote:
> > Plenty of older drivers are still using Scsi_Cmd. The following patches
> > remove its use and changes them for "struct scsi_cmnd". There is also no
> > need for the drivers/scsi/scsi_typedefs.h file anymore since this only
> > contains the typedef for Scsi_Cmd. 

> 
> Thanks for doing this. What a grate relief.
> 
> One thing that I'm missing is the actual patch to remove the
> scsi_typedefs.h file. Is it still used?

Oops, you're right, sending now.

Thanks,
Davidlohr

Signed-off-by: Davidlohr Bueso <dave@gnu.org>

---
 drivers/scsi/scsi_typedefs.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)
 delete mode 100644 drivers/scsi/scsi_typedefs.h

diff --git a/drivers/scsi/scsi_typedefs.h b/drivers/scsi/scsi_typedefs.h
deleted file mode 100644
index 2ed4c5c..0000000
--- a/drivers/scsi/scsi_typedefs.h
+++ /dev/null
@@ -1,2 +0,0 @@
-
-typedef struct scsi_cmnd Scsi_Cmnd;
-- 
1.6.3.3
