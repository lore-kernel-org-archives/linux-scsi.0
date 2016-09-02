From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] wd719x: Remove last declaration using DEFINE_PCI_DEVICE_TABLE
Date: Fri, 02 Sep 2016 06:36:05 -0400
Message-ID: <yq1lgzatwq2.fsf@sermon.lab.mkp.net>
References: <cover.1472660229.git.joe@perches.com>
        <95c5e4100c3cd4eda643624f5b70e8d7abceb86c.1472660229.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <95c5e4100c3cd4eda643624f5b70e8d7abceb86c.1472660229.git.joe@perches.com>
        (Joe Perches's message of "Wed, 31 Aug 2016 09:19:28 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Joe" == Joe Perches <joe@perches.com> writes:

Joe> Convert it to the preferred const struct pci_device_id instead.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
