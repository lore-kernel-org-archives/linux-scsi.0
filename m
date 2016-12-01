From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi/ipr: Fix runaway IRQs when falling back from MSI to LSI
Date: Wed, 30 Nov 2016 19:58:33 -0500
Message-ID: <yq1lgw0h3d2.fsf@sermon.lab.mkp.net>
References: <1479947042.10230.88.camel@kernel.crashing.org>
        <683a1049-2ff3-2777-b908-062212008ae4@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <683a1049-2ff3-2777-b908-062212008ae4@linux.vnet.ibm.com> (Brian
        King's message of "Wed, 30 Nov 2016 15:28:55 -0600")
Sender: linux-kernel-owner@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linuxppc dev list <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Brian" == Brian King <brking@linux.vnet.ibm.com> writes:

Brian> Looks good. Thanks! Here is an updated version that should apply
Brian> cleanly on top of scsi-next.

Applied to 4.10/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
