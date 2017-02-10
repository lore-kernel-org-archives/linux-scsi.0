From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] zfcp: fix use-after-free by not tracing WKA port open/close on failed send
Date: Thu, 09 Feb 2017 19:02:48 -0500
Message-ID: <yq1d1eqkj4n.fsf@oracle.com>
References: <20170208143422.64943-1-maier@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170208143422.64943-1-maier@linux.vnet.ibm.com> (Steffen
        Maier's message of "Wed, 8 Feb 2017 15:34:22 +0100")
Sender: stable-owner@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, "#2 . 6 . 38+" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Steffen" == Steffen Maier <maier@linux.vnet.ibm.com> writes:

Steffen> Rather than relying on req being NULL (or ERR_PTR) for all
Steffen> cases where we don't want to trace or should not trace, simply
Steffen> check retval which is unconditionally initialized with -EIO !=
Steffen> 0 and it can only become 0 on successful retval =
Steffen> zfcp_fsf_req_send(req).  With that we can also remove the then
Steffen> again unnecessary unconditional initialization of req which was
Steffen> introduced with that earlier commit.

Applied to 4.10/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
