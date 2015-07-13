From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v2] qla2xxx: use t10_pi_tuple
Date: Sun, 12 Jul 2015 18:28:55 -0700
Message-ID: <55A31457.1070002@sandisk.com>
References: <20150712235425.00001970@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0082.outbound.protection.outlook.com ([157.56.111.82]:9568
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751397AbbGMB3B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Jul 2015 21:29:01 -0400
In-Reply-To: <20150712235425.00001970@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Herbszt <herbszt@gmx.de>, linux-scsi@vger.kernel.org
Cc: qla2xxx-upstream@qlogic.com

On 07/12/15 14:54, Sebastian Herbszt wrote:
> Drop unused scsi_dif_tuple and use t10_pi_tuple instead of own sd_dif_tuple copy.
> Also use sg_virt() instead of open coding it.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>


