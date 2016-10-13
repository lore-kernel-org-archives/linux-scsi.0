From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] zfcp: spin_lock_irqsave() is not nestable
Date: Thu, 13 Oct 2016 14:27:38 +0300
Message-ID: <20161013112737.GE5687@mwanda>
References: <20161013085358.GH16198@mwanda>
 <409dfaed-85eb-01ba-539d-df95f008a6bf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <409dfaed-85eb-01ba-539d-df95f008a6bf@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Hendrik =?iso-8859-1?Q?Br=FCckner?= <brueckner@linux.vnet.ibm.com>, Gerald Schaefer <gerald.schaefer@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 13, 2016 at 12:49:18PM +0200, Steffen Maier wrote:
> Dan, many thanks for catching this! Sparse did not notice, is there
> other tooling that would find such things?

This was a Smatch warning.

regards,
dan carpenter
