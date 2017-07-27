From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 2/2] scsi: aacraid: Off by one NUL terminator
Date: Thu, 27 Jul 2017 12:00:35 +0300
Message-ID: <20170727090035.iqqavxvuc6hntjhs@mwanda>
References: <20170725195110.uwrzzkzvrbfqv7ld@mwanda>
 <yq1wp6uwp9c.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1wp6uwp9c.fsf@oracle.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

It would be simple enough to write it like you say, but it probably
should be done by someone who is able to test it.

regards,
dan carpenter

