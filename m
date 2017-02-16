From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 04/16] aacraid: Prevent E3 lockup when deleting units
Date: Thu, 16 Feb 2017 08:40:31 +0100
Message-ID: <5cab20d1-15a8-861c-8cc3-47de3414c78c@suse.de>
References: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170214204446.14808-5-RaghavaAditya.Renukunta@microsemi.com>
 <20bffbde-6a46-96f3-f0ee-889d9a029721@suse.de>
 <4D8E82A446BF54499747901DBDEB737A7B8C17BA@avsrvexchmbx2.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59648 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752712AbdBPHke (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Feb 2017 02:40:34 -0500
In-Reply-To: <4D8E82A446BF54499747901DBDEB737A7B8C17BA@avsrvexchmbx2.microsemi.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Dave Carroll <david.carroll@microsemi.com>, Gana Sridaran <gana.sridaran@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>

On 02/15/2017 07:08 PM, Raghava Aditya Renukunta wrote:
> 
> I will put in the queue for the next set of patch submissions and chip away
>  at it bit by bit.

Yay, thanks.

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
