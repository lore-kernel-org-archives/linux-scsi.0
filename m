From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 0/3] scsi: storvsc: Increase the tablesize based on host's
 capabilities
Date: Mon, 16 Mar 2015 23:47:05 +0000
Message-ID: <BY2PR0301MB0711256E189FFDD60D4F6149A0020@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1425958941-23374-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0130.outbound.protection.outlook.com ([65.55.169.130]:51008
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932190AbbCPXrJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Mar 2015 19:47:09 -0400
In-Reply-To: <1425958941-23374-1-git-send-email-kys@microsoft.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>



> -----Original Message-----
> From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> Sent: Monday, March 9, 2015 8:42 PM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com;
> jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.org;
> apw@canonical.com; vkuznets@redhat.com
> Cc: KY Srinivasan
> Subject: [PATCH 0/3] scsi: storvsc: Increase the tablesize based on host's
> capabilities
> 
> Presently, storvsc limits the I/O size arbitrarily. Make this configurable based
> on what the host advertises.
> 
> K. Y. Srinivasan (3):
>   scsi: storvsc: Retrieve information about the capability of the
>     target
>   scsi: storvsc: Set the tablesize based on the information given by
>     the host
>   scsi: storvsc: Enable clustering
> 
>  drivers/scsi/storvsc_drv.c |   78
> +++++++++++++++++++++++++++++++++++---------
>  1 files changed, 62 insertions(+), 16 deletions(-)

Christoph,

Let me know if I should resend these patches.

Regards,

K. Y
> 
> --
> 1.7.4.1

