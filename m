From: Daniel Walker <dwalker@fifo99.com>
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA - V4.
Date: Tue, 08 Sep 2009 18:26:36 -0700
Message-ID: <1252459596.14793.46.camel@desktop>
References: <1252458903.24914.73.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fifo99.com ([67.223.236.141]:55039 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749AbZIIB0P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Sep 2009 21:26:15 -0400
In-Reply-To: <1252458903.24914.73.camel@ank32.eng.vmware.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akataria@vmware.com
Cc: James Bottomley <James.Bottomley@suse.de>, Rolf Eike Beer <eike-kernel@sf-tec.de>, Brian King <brking@linux.vnet.ibm.com>, "Chetan.Loke@Emulex.Com" <Chetan.Loke@Emulex.Com>, Matthew Wilcox <matthew@wil.cx>, Roland Dreier <rdreier@cisco.com>, Bart Van Assche <bvanassche@acm.org>, Robert Love <robert.w.love@intel.com>, Randy Dunlap <randy.dunlap@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, pv-drivers@vmware.com

On Tue, 2009-09-08 at 18:15 -0700, Alok Kataria wrote:
> +typedef struct PVSCSIRingCmpDesc {
> +       u64     context;
> +       u64     dataLen;
> +       u32     senseLen;
> +       u16     hostStatus;
> +       u16     scsiStatus;
> +       u32     _pad[2];
> +} __packed PVSCSIRingCmpDesc;


I get a lot of checkpatch warnings due to the typedefs here.. They are
usually frowned upon, and it really does make you code look alien ..

> +#define PVSCSI_MEM_SPACE_COMMAND_PAGE          0
> +#define PVSCSI_MEM_SPACE_INTR_STATUS_PAGE      1
> +#define PVSCSI_MEM_SPACE_MISC_PAGE             2
> +#define PVSCSI_MEM_SPACE_KICK_IO_PAGE          4
> +#define PVSCSI_MEM_SPACE_MSIX_TABLE_PAGE       6
> +#define PVSCSI_MEM_SPACE_MSIX_PBA_PAGE         7

Why not use an enum for the above? Your using enums in the rest of your
code..

Daniel

