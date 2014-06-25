From: "Reddy, Sreekanth" <Sreekanth.Reddy@avagotech.com>
Subject: [PATCH][SCSI]mpt3sas: Description Patch
Date: Wed, 25 Jun 2014 16:08:11 +0530
Message-ID: <20140625103811.GA12983@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, JBottomley@Parallels.com
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, sreekanth.reddy@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

Just resending below set of patches which I have sent on 14th March 2014.
And I have removed below subjected patch since we have already have the
module parameter port_mask to disable EEDP support.
[PATCH 1/9][SCSI]mpt3sas: Added new driver module Parameter disable_eedp to Disable EEDP Support.

Please consider this patch set for next kernel release.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---

[RESEND][PATCH 1/8][SCSI]mpt3sas: MPI2.5 Rev G (2.5.2) specifications.
[RESEND][PATCH 2/8][SCSI]mpt3sas: Clear PFA Status on SGPIO when PFA Drive is Removed or Replaced.
[RESEND][PATCH 3/8][SCSI]mpt3sas: Bump mpt3sas driver version to 03.100.00.00.
[RESEND][PATCH 4/8][SCSI]mpt3sas: MPI2.5 Rev H (2.5.3) specifications.
[RESEND][PATCH 5/8][SCSI]mpt3sas: Copyright in driver sources is updated for year the 2014.
[RESEND][PATCH 6/8][SCSI]mpt3sas: Added OEM branding Strings.
[RESEND][PATCH 7/8][SCSI]mpt3sas: Added Reply Descriptor Post Queue (RDPQ) Array support.
[RESEND][PATCH 8/8][SCSI]mpt3sas: Bump mpt3sas driver version to 04.100.00.00.
