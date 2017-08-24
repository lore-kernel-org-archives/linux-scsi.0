From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qedf: Fix a potential NULL pointer dereference
Date: Wed, 23 Aug 2017 22:43:29 -0400
Message-ID: <yq1h8wxadny.fsf@oracle.com>
References: <20170820170935.14767-1-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170820170935.14767-1-christophe.jaillet@wanadoo.fr>
        (Christophe JAILLET's message of "Sun, 20 Aug 2017 19:09:35 +0200")
Sender: kernel-janitors-owner@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: QLogic-Storage-Upstream@cavium.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Christophe,

> At the beginning of 'qedf_srr_compl()' and of 'qedf_rec_compl()', we
> check if 'orig_io_req' is NULL. If this happens, a NULL pointer
> dereference will occur in the error handling path.

Applied to 4.13/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
