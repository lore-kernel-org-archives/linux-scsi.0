From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: cxlflash: Fix an error handling path in
 'cxlflash_disk_attach()'
Date: Tue, 15 Aug 2017 19:21:31 -0500
Message-ID: <D62EAC69-693C-4231-95F9-B48F47AB241C@linux.vnet.ibm.com>
References: <20170815201814.12929-1-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170815201814.12929-1-christophe.jaillet@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> On Aug 15, 2017, at 3:18 PM, Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:
> 
> 'rc' is known to be 0 at this point.
> If 'create_context()' fails, returns -ENOMEM instead of 0 which means
> success.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Yep, that's a bug.

Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
