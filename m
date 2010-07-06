From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: 520 BPS data integrity vendors
Date: Tue, 06 Jul 2010 14:53:05 -0400
Message-ID: <yq1630s8msu.fsf@sermon.lab.mkp.net>
References: <AANLkTilcpFgsYtEUkZ2zAU3SDs0jetiajYPzKUWgFMyD@mail.gmail.com>
	<1278093968.2856.169.camel@mulgrave.site>
	<AANLkTilWKeOAXMukh_zvXzdXkdOTk6soAEnpzFNwvBA3@mail.gmail.com>
	<yq1mxu981eg.fsf@sermon.lab.mkp.net>
	<AANLkTimI7Ke4qXw7zv8WDsWSQtBRSwSi5IZbvByjGRih@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <AANLkTimI7Ke4qXw7zv8WDsWSQtBRSwSi5IZbvByjGRih@mail.gmail.com>
	(Dan Porat's message of "Tue, 6 Jul 2010 14:01:07 -0400")
Sender: linux-ide-owner@vger.kernel.org
To: Dan Porat <dan.porat@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@suse.de>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Dan" == Dan Porat <dan.porat@gmail.com> writes:

Dan> We checked with kernel 2.6.34 , Seagate Cheetah 15K and the
Dan> following HBA: LSI 9212-4i4e

Dan> Still , no success.

Send us the output of:

# lsscsi -p
# sg_inq -x /dev/sdN
# sg_readcap -l /dev/sdN


Dan> Any Ideas?

And you are sure that the drive is formatted with DIF?  Seagate's
standard firmware doesn't support it, fwiw.  It's a build-to-order
option.

Hitachi drives support DIF out of the box.

-- 
Martin K. Petersen	Oracle Linux Engineering
