From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: zero per-cmd driver data for each MQ I/O
Date: Wed, 17 May 2017 23:54:54 -0700
Message-ID: <20170518065454.GA25180@infradead.org>
References: <MWHPR03MB31361482F0BAE79275957D63CEE10@MWHPR03MB3136.namprd03.prod.outlook.com>
 <1494892845.2567.14.camel@sandisk.com>
 <MWHPR03MB3136DEB8FD09EDDF7CDB8BF5CEE60@MWHPR03MB3136.namprd03.prod.outlook.com>
 <1495062317.2679.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1495062317.2679.1.camel@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "longli@microsoft.com" <longli@microsoft.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "sthemmin@microsoft.com" <sthemmin@microsoft.com>, "kys@microsoft.com" <kys@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, May 17, 2017 at 11:05:18PM +0000, Bart Van Assche wrote:
> Thank you for the feedback. I'm working on a patch series that merges the scsi-sq
> and scsi-mq code paths for command initialization and that should fix the bug you
> encountered.

While that sounds great (I tried it a while ago but gave up due to
priorities) I think we should merge this patch as-is and backport it
to stable for now and rebase your series on top of it.
