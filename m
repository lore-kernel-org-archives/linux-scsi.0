From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: libfc: fix incorrect variable assingment
Date: Tue, 16 May 2017 21:09:41 -0400
Message-ID: <yq1shk49tm2.fsf@oracle.com>
References: <20170511222444.GA6604@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170511222444.GA6604@embeddedgus> (Gustavo A. R. Silva's
        message of "Thu, 11 May 2017 17:24:44 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Cc: Johannes Thumshirn <jth@kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Gustavo A.,

> Previous assignment was causing the use of the uninitialized variable
> _explan_ inside fc_seq_ls_rjt() function, which in this particular
> case is being called by fc_seq_els_rsp_send().

Applied to 4.12/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
