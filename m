From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH V3 03/24] aacraid: added support for init_struct_8
Date: Mon, 30 Jan 2017 10:15:00 +0100
Message-ID: <20170130091500.GA3603@linux-x5ow.site>
References: <20170127192853.10082-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170127192853.10082-4-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44087 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752101AbdA3JQT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Jan 2017 04:16:19 -0500
Content-Disposition: inline
In-Reply-To: <20170127192853.10082-4-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com

On Fri, Jan 27, 2017 at 11:28:32AM -0800, Raghava Aditya Renukunta wrote:
> This  patch lays the groundwork for supporting the new HBA-1000 controller
> family.A new INIT structure INIT_STRUCT_8 has been added which allows for a
> variable size for MSI-x vectors among other things,  and is used for both
> Series-8, HBA-1000 and SmartIOC-2000.
> 
> Signed-off-by: Raghava Aditya Renukunta <raghavaaditya.renukunta@microsemi.com>
> Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
> 
> ---

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
