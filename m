From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] megaraid_sas: fix macro MEGASAS_IS_LOGICAL to avoid regression caused by commit 1e793f6fc0db920400574211c48f9157a37e3945
Date: Wed, 09 Nov 2016 11:30:52 -0500
Message-ID: <yq1wpgcobsz.fsf@sermon.lab.mkp.net>
References: <1478689182-10854-1-git-send-email-sumit.saxena@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1478689182-10854-1-git-send-email-sumit.saxena@broadcom.com>
        (Sumit Saxena's message of "Wed, 9 Nov 2016 02:59:42 -0800")
Sender: stable-owner@vger.kernel.org
To: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, shivasharan.srikanteshwara@broadcom.com, axboe@kernel.dk, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sumit" == Sumit Saxena <sumit.saxena@broadcom.com> writes:

Sumit> This patch will fix regression caused by below commit- 1e793f6
Sumit> scsi: megaraid_sas: Fix data integrity failure for JBOD
Sumit> (passthrough) devices

Sumit> The problem was MEGASAS_IS_LOGICAL macro does not have braces and
Sumit> because of above commit using this macro was exposing lot of
Sumit> non-existing SCSI devices(all SCSI commands to channels-1,2,3 was
Sumit> returned as SUCCESS-DID_OK by driver).

Applied to 4.9/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
