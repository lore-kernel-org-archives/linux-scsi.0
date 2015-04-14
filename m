From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC] Simlify dif_verify routines and fixup fileio protection information code.
Date: Mon, 13 Apr 2015 21:23:05 -0400
Message-ID: <yq1y4lv5wqu.fsf@sermon.lab.mkp.net>
References: <1428945575-30839-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1428945575-30839-1-git-send-email-sagig@mellanox.com> (Sagi
	Grimberg's message of "Mon, 13 Apr 2015 20:19:33 +0300")
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Akinobu Mita <akinobu.mita@gmail.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sagi" == Sagi Grimberg <sagig@mellanox.com> writes:

Sagi> This set follows the patchset from Akinobu Mita that addresses DIF
Sagi> bounce buffer sgl construction. Instead of trying to fix these
Sagi> bugs, this removes it altogether and work with cmd->t_prot_sg
Sagi> directly.

Sagi> The first patch is a simplification of the DIF verify varius
Sagi> routines leaving a single generic sbc_dif_verify that handles the
Sagi> protection information sgl we are working on.

Sagi> The second patch uses this simplification to remove the local
Sagi> prot_fd bounce buffer altogether.

Looks like a nice cleanup to me.

-- 
Martin K. Petersen	Oracle Linux Engineering
