From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/3] Restrict scsi accessors access to read-only
Date: Thu, 14 Jun 2007 14:50:11 -0400
Message-ID: <46718DE3.3000401@garzik.org>
References: <466EDFAC.9020104@panasas.com>	<20070613085118P.fujita.tomonori@lab.ntt.co.jp>	<E472128B1EB43941B4E7FB268020C89B0250B912@riverside.int.panasas.com> <20070613194513H.fujita.tomonori@lab.ntt.co.jp> <46716C45.1090107@panasas.com> <46716DD3.1030501@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:48298 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523AbXFNSuT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Jun 2007 14:50:19 -0400
In-Reply-To: <46716DD3.1030501@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Ed Lin <ed.lin@promise.com>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-scsi@vger.kernel.org

Boaz Harrosh wrote:
> +static inline struct scatterlist *scsi_sglist(struct scsi_cmnd *cmd)
> +{
> +	return (struct scatterlist *)cmd->request_buffer;
> +}


It is quite nice to have this accessor, especially.

	Jeff


