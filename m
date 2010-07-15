From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: 520 BPS data integrity vendors
Date: Thu, 15 Jul 2010 09:47:32 -0400
Message-ID: <yq17hkwrh57.fsf@sermon.lab.mkp.net>
References: <AANLkTilcpFgsYtEUkZ2zAU3SDs0jetiajYPzKUWgFMyD@mail.gmail.com>
	<1278093968.2856.169.camel@mulgrave.site>
	<AANLkTilWKeOAXMukh_zvXzdXkdOTk6soAEnpzFNwvBA3@mail.gmail.com>
	<yq1mxu981eg.fsf@sermon.lab.mkp.net>
	<AANLkTimI7Ke4qXw7zv8WDsWSQtBRSwSi5IZbvByjGRih@mail.gmail.com>
	<yq1630s8msu.fsf@sermon.lab.mkp.net>
	<AANLkTilqzgIav9noTYLC9cxKtntva6wQwLSUI1i8DgAe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <AANLkTilqzgIav9noTYLC9cxKtntva6wQwLSUI1i8DgAe@mail.gmail.com>
	(Dan Porat's message of "Thu, 15 Jul 2010 06:08:09 -0400")
Sender: linux-ide-owner@vger.kernel.org
To: Dan Porat <dan.porat@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@suse.de>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Dan" == Dan Porat <dan.porat@gmail.com> writes:

Dan> [root@fedora13 ~]# sg_inq /dev/sdb
[...]
Dan> [root@fedora13 ~]# sg_readcap /dev/sdb
[...]

I asked for EXTENDED INQUIRY and READ CAPACITY(16).

# sg_inq -x /dev/sdb
# sg_readcap -l /dev/sdb

It does not look like you have reformatted the drive, though...

-- 
Martin K. Petersen	Oracle Linux Engineering
