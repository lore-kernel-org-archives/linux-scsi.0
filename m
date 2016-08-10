From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH V4 1/2] smartpqi: initial commit of Microsemi smartpqi
 driver
Date: Wed, 10 Aug 2016 12:12:31 -0400
Message-ID: <1470845551.12971.19.camel@localhost.localdomain>
References: <146706289746.29152.13840476577189238722.stgit@brunhilda>
	 <146706366077.29152.2433812429429846745.stgit@brunhilda>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936514AbcHJSmb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Aug 2016 14:42:31 -0400
In-Reply-To: <146706366077.29152.2433812429429846745.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com, linux-scsi@vger.kernel.org

On Mon, 2016-06-27 at 16:41 -0500, Don Brace wrote:
> From: Kevin Barnett <kevin.barnett@microsemi.com>
> 
> This initial commit contains WIP of Microsemi's smartpqi module.
> 
> Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
> Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
> Signed-off-by: Don Brace <don.brace@microsemi.com>
> ---
>  MAINTAINERS                                    |   11 
>  drivers/scsi/Kconfig                           |    1 
>  drivers/scsi/Makefile                          |    1 
>  drivers/scsi/smartpqi/Kconfig                  |   50 
>  drivers/scsi/smartpqi/Makefile                 |    3 
>  drivers/scsi/smartpqi/smartpqi.h               | 1133 ++++
>  drivers/scsi/smartpqi/smartpqi_init.c          | 6306 ++++++++++++++++++++++++
>  drivers/scsi/smartpqi/smartpqi_sas_transport.c |  350 +
>  drivers/scsi/smartpqi/smartpqi_sis.c           |  394 +
>  drivers/scsi/smartpqi/smartpqi_sis.h           |   32 
>  10 files changed, 8281 insertions(+)
>  create mode 100644 drivers/scsi/smartpqi/Kconfig
>  create mode 100644 drivers/scsi/smartpqi/Makefile
>  create mode 100644 drivers/scsi/smartpqi/smartpqi.h
>  create mode 100644 drivers/scsi/smartpqi/smartpqi_init.c
>  create mode 100644 drivers/scsi/smartpqi/smartpqi_sas_transport.c
>  create mode 100644 drivers/scsi/smartpqi/smartpqi_sis.c
>  create mode 100644 drivers/scsi/smartpqi/smartpqi_sis.h
> 

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


