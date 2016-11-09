From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/2] qla2xxx: fix errors in PCI device remove with ongoing I/O
Date: Tue, 08 Nov 2016 19:14:35 -0500
Message-ID: <yq1pom5pl04.fsf@sermon.lab.mkp.net>
References: <1478548411-17932-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1478548411-17932-1-git-send-email-mauricfo@linux.vnet.ibm.com>
        (Mauricio Faria de Oliveira's message of "Mon, 7 Nov 2016 17:53:29
        -0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Cc: qla2xxx-upstream@qlogic.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Mauricio" == Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com> writes:

Mauricio> This patchset addresses a couple of errors that might happen
Mauricio> during PCI device remove (e.g., PCI hotplug, PowerVM DLPAR),
Mauricio> which prevent the successful removal and re-addition of the
Mauricio> adapter to the system, and cause an oops and/or invalid DMA
Mauricio> access (triggers an EEH event).

Applied to 4.9/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
