From: Alexey Dobriyan <adobriyan@mail.ru>
Subject: Re: [ANNOUNCE 3/6] Open-iSCSI High-Performance Initiator for Linux
Date: Mon, 7 Mar 2005 11:44:18 +0200
Message-ID: <200503071144.19133.adobriyan@mail.ru>
References: <422BFF88.50205@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
In-Reply-To: <422BFF88.50205@yahoo.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Alex Aizman <itn780@yahoo.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Monday 07 March 2005 09:15, Alex Aizman wrote:
>           drivers/scsi/Kconfig changes.

> --- linux-2.6.11.orig/drivers/scsi/Kconfig
> +++ linux-2.6.11.dima/drivers/scsi/Kconfig

> +config ISCSI_IF
> +	tristate "iSCSI Open Transport Interface"
> +	depends on SCSI && INET
> +	---help---
> +	To compile this driver as a module, choose M here: the
> +	module will be called iscsi_if.
> +
> +	This driver manages multiple iSCSI transports. This module is required
> +	for normal iscsid operation.
> +
> +	See more detailed information here:
> +
> + 	http://www.open-iscsi.org

"To compile this driver as a module ..." boilerplate usually goes at the end
of description. Help text is indented with 2 spaces wrt "---help---":

	---help---
	  This driver manages multiple iSCSI transports. ...

	Alexey
