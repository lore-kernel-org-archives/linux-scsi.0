From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 4.8 11/37] scsi: mpt3sas: Fix secure erase premature termination
Date: Wed, 30 Nov 2016 11:49:56 -0500
Message-ID: <yq1k2bkj4jv.fsf@sermon.lab.mkp.net>
References: <20161130092729.623248210@linuxfoundation.org>
        <20161130092730.337406282@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161130092730.337406282@linuxfoundation.org> (Greg
        Kroah-Hartman's message of "Wed, 30 Nov 2016 10:29:48 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, Andrey Grodzovsky <andrey2805@gmail.com>, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Greg" == Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

Greg,

Greg> From: Andrey Grodzovsky <andrey2805@gmail.com>

Greg> commit 18f6084a989ba1b38702f9af37a2e4049a924be6 upstream.

Please also queue 7ff723ad0f87 ("scsi: mpt3sas: Unblock device after
controller reset") which just hit Linus' tree. It's a bug fix for the
patch above.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
