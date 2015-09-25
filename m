From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: Bugs in multipath scsi in 4.3-rc2
Date: Fri, 25 Sep 2015 09:28:12 -0700
Message-ID: <5605761C.4070304@sandisk.com>
References: <20150925121636.GC12540@fergus.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0097.outbound.protection.outlook.com ([157.56.111.97]:16208
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755763AbbIYQ2R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Sep 2015 12:28:17 -0400
In-Reply-To: <20150925121636.GC12540@fergus.ozlabs.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Mackerras <paulus@ozlabs.org>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 09/25/2015 05:16 AM, Paul Mackerras wrote:
> diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
> index edb044a..86a3063 100644
> --- a/drivers/scsi/scsi_dh.c
> +++ b/drivers/scsi/scsi_dh.c
> @@ -111,7 +111,7 @@ static struct scsi_device_handler *scsi_dh_lookup(const char *name)
>
>   	dh = __scsi_dh_lookup(name);
>   	if (!dh) {
> -		request_module(name);
> +		request_module("scsi_dh_%s", name);
>   		dh = __scsi_dh_lookup(name);
>   	}

Tested-by: Bart Van Assche <bart.vanassche@sandisk.com>
