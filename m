From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] scsi: lpfc: avoid harmless comparison warning
Date: Wed, 20 Jul 2016 19:54:11 -0400
Message-ID: <yq1vazzeuho.fsf@sermon.lab.mkp.net>
References: <20160615204231.3784044-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160615204231.3784044-1-arnd@arndb.de> (Arnd Bergmann's message
	of "Wed, 15 Jun 2016 22:42:17 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, Hannes Reinicke <hare@suse.de>, James Bottomley <JBottomley@Odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Arnd" == Arnd Bergmann <arnd@arndb.de> writes:

Arnd> When building with -Wextra, we get a lot of warnings for the lpfc
Arnd> driver concerning expressions that are always true, starting with:

Applied to 4.8/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
