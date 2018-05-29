From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi_transport_srp: Fix shost to rport translation
Date: Mon, 28 May 2018 21:26:05 -0400
Message-ID: <yq1in7745hu.fsf@oracle.com>
References: <20180521181729.12821-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180521181729.12821-1-bart.vanassche@wdc.com> (Bart Van
        Assche's message of "Mon, 21 May 2018 11:17:29 -0700")
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Jason Gunthorpe <jgg@mellanox.com>, Doug Ledford <dledford@redhat.com>, Laurence Oberman <loberman@redhat.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Bart,

> Since an SRP remote port is attached as a child to shost->shost_gendev
> and as the only child, the translation from the shost pointer into an
> rport pointer must happen by looking up the shost child that is an
> rport. This patch fixes the following KASAN complaint:

Applied to 4.17/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
