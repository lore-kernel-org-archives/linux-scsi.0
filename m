From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 6/6] qla2xxx: Refactor usage of Active command arrays
Date: Tue, 25 Jul 2017 10:19:44 +0200
Message-ID: <20170725081944.GF3750@linux-x5ow.site>
References: <20170721163228.32339-1-himanshu.madhani@cavium.com>
 <20170721163228.32339-7-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50001 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750757AbdGYITq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Jul 2017 04:19:46 -0400
Content-Disposition: inline
In-Reply-To: <20170721163228.32339-7-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org

On Fri, Jul 21, 2017 at 09:32:28AM -0700, Himanshu Madhani wrote:
> +typedef enum {
> +	TYPE_SRB,
> +	TYPE_TGT_CMD,
> +} cmd_type_t;

Minor Nitpick if you have to re-send, please no typedefs.

Anyways,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
