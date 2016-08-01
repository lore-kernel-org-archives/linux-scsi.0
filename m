From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V4 1/2] smartpqi: initial commit of Microsemi smartpqi
 driver
Date: Mon, 1 Aug 2016 09:13:00 +0200
Message-ID: <69c8edfa-6b40-2976-f73f-155abacb06cc@suse.de>
References: <146706289746.29152.13840476577189238722.stgit@brunhilda>
 <146706366077.29152.2433812429429846745.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60014 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbcHAHNC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Aug 2016 03:13:02 -0400
In-Reply-To: <146706366077.29152.2433812429429846745.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 06/27/2016 11:41 PM, Don Brace wrote:
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
Despite 'pragma(pack)' still being present:

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
