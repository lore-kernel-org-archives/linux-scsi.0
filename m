From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] SCSI-lpfc: Use a signed return type for two functions
Date: Sat, 19 Dec 2015 23:17:07 +0300
Message-ID: <20151219201707.GR5284@mwanda>
References: <5675A576.8020008@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5675A576.8020008@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-scsi@vger.kernel.org, Dick Kennedy <dick.kennedy@avagotech.com>, "James E. J. Bottomley" <JBottomley@odin.com>, James Smart <james.smart@avagotech.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

It returns zero or negative error codes.  The callers expect int.  The
current code is harmless.  It should return an int.

regards,
dan carpenter
