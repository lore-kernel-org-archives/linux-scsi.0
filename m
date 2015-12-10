From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] VMW_PVSCSI: Fix the issue of DMA-API related warnings.
Date: Thu, 10 Dec 2015 12:58:00 -0500
Message-ID: <yq18u522nkn.fsf@sermon.lab.mkp.net>
References: <20151203132758.GC19092@hansolo.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151203132758.GC19092@hansolo.redhat.com> (Josh Boyer's message
	of "Thu, 3 Dec 2015 08:27:59 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: James.Bottomley@hansenpartnership.com, arvindkumar@vmware.com, Thomas Hellstrom <thellstrom@vmware.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, pv-drivers@vmware.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Josh" == Josh Boyer <jwboyer@fedoraproject.org> writes:

Josh> The driver is missing calls to pci_dma_mapping_error() after
Josh> performing the DMA mapping, which caused DMA-API warning to show
Josh> up in dmesg's output. Though that happens only when DMA_API_DEBUG
Josh> option is enabled. This change fixes the issue and makes
Josh> pvscsi_map_buffers() function more robust.

Applied to 4.5/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
