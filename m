From: Calvin Owens <calvinowens@fb.com>
Subject: [PATCH v4 0/2] Fixes for memory corruption in mpt2sas
Date: Thu, 13 Aug 2015 18:48:08 -0700
Message-ID: <1439516890-3548744-1-git-send-email-calvinowens@fb.com>
References: <1438405334-1153698-1-git-send-email-calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438405334-1153698-1-git-send-email-calvinowens@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>
Cc: MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, calvinowens@fb.com, Joe Lawrence <joe.lawrence@stratus.com>
List-Id: linux-scsi@vger.kernel.org

Hello all,

This patchset attempts to address problems we've been having with
panics due to memory corruption from the mpt2sas driver.

Thanks,
Calvin


[PATCH v4 1/2] mpt2sas: Refcount sas_device objects and fix unsafe list
[PATCH v4 2/2] mpt2sas: Refcount fw_events and fix unsafe list usage

Total diffstat:
 drivers/scsi/mpt2sas/mpt2sas_base.h      |  22 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c     | 592 ++++++++++++++++++++++---------
 drivers/scsi/mpt2sas/mpt2sas_transport.c |  12 +-
 3 files changed, 451 insertions(+), 175 deletions(-)

Diff showing changes v3 => v4:
	http://jcalvinowens.github.io/stuff/mpt2sas-patchset-v3v4.patch

Diff showing changes v2 => v3:
	http://jcalvinowens.github.io/stuff/mpt2sas-patchset-v2v3.patch

Diff showing changes v1 => v2:
	http://jcalvinowens.github.io/stuff/mpt2sas-patchset-v1v2.patch
