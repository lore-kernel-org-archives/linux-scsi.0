From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] qla2xxx: do not abort all commands in the adapter during EEH recovery
Date: Mon, 14 Nov 2016 18:39:37 -0500
Message-ID: <yq1a8d1fx6u.fsf@sermon.lab.mkp.net>
References: <1479158782-4544-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1479158782-4544-1-git-send-email-mauricfo@linux.vnet.ibm.com>
        (Mauricio Faria de Oliveira's message of "Mon, 14 Nov 2016 19:26:22
        -0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Cc: Himanshu.Madhani@cavium.com, qla2xxx-upstream@qlogic.com, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Mauricio" == Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com> writes:

Mauricio> The previous commit ("qla2xxx: fix invalid DMA access after
Mauricio> command aborts in PCI device remove") introduced a regression
Mauricio> during an EEH recovery, since the change to the
Mauricio> qla2x00_abort_all_cmds() function calls qla2xxx_eh_abort(),
Mauricio> which verifies the EEH recovery condition but handles it
Mauricio> heavy-handed. (commit a465537ad1a4 "qla2xxx: Disable the
Mauricio> adapter and skip error recovery in case of register
Mauricio> disconnect.")

Applied to 4.9/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
