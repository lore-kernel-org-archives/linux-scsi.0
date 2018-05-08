From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] mptlan: fix mpt_lan_sdu_send()'s return type
Date: Tue, 08 May 2018 01:21:56 -0400
Message-ID: <yq1h8niyb63.fsf@oracle.com>
References: <20180424131558.3010-1-luc.vanoostenryck@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180424131558.3010-1-luc.vanoostenryck@gmail.com> (Luc Van
        Oostenryck's message of "Tue, 24 Apr 2018 15:15:58 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Luc,

> The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
> which is a typedef for an enum type, but the implementation in this
> driver returns an 'int'.

You forgot to update the function prototype accordingly.

-- 
Martin K. Petersen	Oracle Linux Engineering
