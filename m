From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] libfc: Fix variable name in fc_set_wwpn
Date: Mon, 16 Jan 2017 15:43:29 -0500
Message-ID: <yq1d1fmlor2.fsf@oracle.com>
References: <20170113034001.29202-1-famz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170113034001.29202-1-famz@redhat.com> (Fam Zheng's message of
        "Fri, 13 Jan 2017 11:40:01 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Fam Zheng <famz@redhat.com>
Cc: linux-kernel@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, fcoe-devel@open-fcoe.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Fam" == Fam Zheng <famz@redhat.com> writes:

Fam> The parameter name should be wwpn instead of wwnn.

Applied to 4.10/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
