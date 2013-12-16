From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 11/20] qla2xxx: Add support for ISP2701.
Date: Mon, 16 Dec 2013 07:56:25 +0100
Message-ID: <52AEA419.8030803@acm.org>
References: <1386965040-20611-1-git-send-email-saurav.kashyap@qlogic.com> <1386965040-20611-12-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp03.stone-is.org ([87.238.162.66]:51524 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab3LPG42 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Dec 2013 01:56:28 -0500
In-Reply-To: <1386965040-20611-12-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Saurav Kashyap <saurav.kashyap@qlogic.com>, jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

On 12/13/13 21:03, Saurav Kashyap wrote:
> +struct __packed qla27xx_fwdt_entry {
> +	struct __packed {
> +		uint32_t entry_type;
> +		uint32_t entry_size;
> +		uint32_t reserved_1;
> +
> +		uint8_t  capture_flags;
> +		uint8_t  reserverd_2[2];
> +		uint8_t  driver_flags;
> +	} hdr;
> + [ ... ]
> +};

In the above I see "reserverd". Shouldn't that have been "reserved"
instead ?

Bart.

