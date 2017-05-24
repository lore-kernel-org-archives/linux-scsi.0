From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] lpfc: nvmet_fc: fix format string
Date: Tue, 23 May 2017 22:36:14 -0400
Message-ID: <yq14lwbvv4x.fsf@oracle.com>
References: <20170519080447.1043039-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170519080447.1043039-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Fri, 19 May 2017 10:04:31 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> The lpfc_nvmeio_data() tracing helper always takes a format string and
> three additional arguments. The latest caller has a format string with
> only two integer arguments, causing this harmless warning:

James?

-- 
Martin K. Petersen	Oracle Linux Engineering
