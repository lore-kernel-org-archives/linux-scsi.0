From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [RESEND][PATCH] qla2xxx: use t10_pi_tuple
Date: Sun, 12 Jul 2015 09:27:17 -0700
Message-ID: <55A29565.2090208@sandisk.com>
References: <20150712160631.000059ca@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0066.outbound.protection.outlook.com ([157.56.111.66]:35707
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750935AbbGLQ1X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Jul 2015 12:27:23 -0400
In-Reply-To: <20150712160631.000059ca@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Herbszt <herbszt@gmx.de>, linux-scsi@vger.kernel.org
Cc: qla2xxx-upstream@qlogic.com

On 07/12/15 07:06, Sebastian Herbszt wrote:
> -			spt = page_address(sg_page(sg)) + sg->offset;
> -			spt += j;
> +			pi = page_address(sg_page(sg)) + sg->offset;
> +			pi += j;

Sorry that I hadn't noticed this before but please use sg_virt() in the 
above code instead of open coding it.

Bart.
