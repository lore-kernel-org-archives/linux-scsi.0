From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 05/16] scsi: fc: provide fc_bsg_to_shost() helper
Date: Thu, 3 Nov 2016 15:07:14 -0700
Message-ID: <94a256b2-37ba-5a9d-f159-8105bf5f804e@linux.vnet.ibm.com>
References: <cover.1476369687.git.jthumshirn@suse.de>
 <17800a02a380bb202e21c62ac7db9801e4c98e1c.1476369687.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33234 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1758152AbcKCWH3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Nov 2016 18:07:29 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uA3M3v7u090295
        for <linux-scsi@vger.kernel.org>; Thu, 3 Nov 2016 18:07:29 -0400
Received: from e38.co.us.ibm.com (e38.co.us.ibm.com [32.97.110.159])
        by mx0b-001b2d01.pphosted.com with ESMTP id 26g7667agp-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 03 Nov 2016 18:07:28 -0400
Received: from localhost
        by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <tyreld@linux.vnet.ibm.com>;
        Thu, 3 Nov 2016 16:07:28 -0600
In-Reply-To: <17800a02a380bb202e21c62ac7db9801e4c98e1c.1476369687.git.jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Steffen Maier <maier@linux.vnet.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Johannes Thumshirn <jth@kernel.org>, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, "supporter:QLOGIC QLA2XXX FC-SCSI DRIVER" <qla2xxx-upst>

On 10/13/2016 08:00 AM, Johannes Thumshirn wrote:
> Provide fc_bsg_to_shost() helper that will become handy when we're moving from
> struct fc_bsg_job to a plain struct bsg_job. Also use this little helper in
> the LLDDs.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> Reviewed-by: Hannes Reinecke <hare@suse.com>

For ibmvfc parts,

Acked-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>

