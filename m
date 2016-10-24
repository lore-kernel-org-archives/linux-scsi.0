From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [patch] zfcp: spin_lock_irqsave() is not nestable
Date: Mon, 24 Oct 2016 10:18:45 +0200
Message-ID: <63c024b9-8662-e521-62e0-e0ebe980b217@de.ibm.com>
References: <20161013085358.GH16198@mwanda>
 <409dfaed-85eb-01ba-539d-df95f008a6bf@linux.vnet.ibm.com>
 <yq11szilm1d.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq11szilm1d.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Steffen Maier <maier@linux.vnet.ibm.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, linux-scsi@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, =?UTF-8?Q?Hendrik_Br=c3=bcckner?= <brueckner@linux.vnet.ibm.com>, Gerald Schaefer <gerald.schaefer@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On 10/14/2016 10:21 PM, Martin K. Petersen wrote:
>>>>>> "Steffen" == Steffen Maier <maier@linux.vnet.ibm.com> writes:
> 
> Steffen> could you please queue this as fix for one of my patches that
> Steffen> went into the 4.9 merge window, so for 4.9-rc I guess?
> 
> Applied to 4.9/scsi-fixes.
> 

FWIW, I do see rcu stall errors with 4.9-rc1 from time to time, so I assume
that this fix is not only theoretical but fixes a real life issue.
