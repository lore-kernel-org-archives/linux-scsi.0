From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 0/6] Add QLogic FastLinQ iSCSI (qedi) driver.
Date: Tue, 29 Nov 2016 12:21:55 -0500
Message-ID: <yq1k2bmmcb0.fsf@sermon.lab.mkp.net>
References: <1478588223-16183-1-git-send-email-manish.rangankar@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1478588223-16183-1-git-send-email-manish.rangankar@cavium.com>
        (Manish Rangankar's message of "Mon, 7 Nov 2016 22:56:57 -0800")
Sender: netdev-owner@vger.kernel.org
To: Manish Rangankar <manish.rangankar@cavium.com>
Cc: martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com, linux-scsi@vger.kernel.org, netdev@vger.kernel.org, QLogic-Storage-Upstream@cavium.com, Yuval.Mintz@cavium.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "Manish" == Manish Rangankar <manish.rangankar@cavium.com> writes:

Manish> This series introduces hardware offload iSCSI initiator driver
Manish> for the 41000 Series Converged Network Adapters (579xx chip) by
Manish> Qlogic. The overall driver design includes a common module
Manish> ('qed') and protocol specific dependent modules ('qedi' for
Manish> iSCSI).

The SCSI portions look reasonably sane to me.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
