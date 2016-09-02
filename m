From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] wd719x: Remove last declaration using
 DEFINE_PCI_DEVICE_TABLE
Date: Fri, 2 Sep 2016 10:16:54 -0700
Message-ID: <20160902101654.4f7e8fd484bfab95444dfe35@linux-foundation.org>
References: <cover.1472660229.git.joe@perches.com>
        <95c5e4100c3cd4eda643624f5b70e8d7abceb86c.1472660229.git.joe@perches.com>
        <yq1lgzatwq2.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1lgzatwq2.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Joe Perches <joe@perches.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 02 Sep 2016 06:36:05 -0400 "Martin K. Petersen" <martin.petersen@oracle.com> wrote:

> >>>>> "Joe" == Joe Perches <joe@perches.com> writes:
> 
> Joe> Convert it to the preferred const struct pci_device_id instead.
> 
> Applied to 4.9/scsi-queue.

That creates an ordering dependency between the scsi tree and -mm's
"treewide: remove references to the now unnecessary
DEFINE_PCI_DEVICE_TABLE".

So an ack would be preferred, please.
