From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [RFC] Simlify dif_verify routines and fixup fileio protection
 information code.
Date: Tue, 14 Apr 2015 21:17:42 +0900
Message-ID: <CAC5umygZ_qCu0x3RfTQs21R1Poa6A10FkhmGak7ccc2HvY4ROQ@mail.gmail.com>
References: <1428945575-30839-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1428945575-30839-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

2015-04-14 2:19 GMT+09:00 Sagi Grimberg <sagig@mellanox.com>:
> Hey All,
>
> This set follows the patchset from Akinobu Mita that addresses
> DIF bounce buffer sgl construction. Instead of trying to fix these
> bugs, this removes it altogether and work with cmd->t_prot_sg
> directly.
>
> The first patch is a simplification of the DIF verify varius
> routines leaving a single generic sbc_dif_verify that handles
> the protection information sgl we are working on.
>
> The second patch uses this simplification to remove the local
> prot_fd bounce buffer altogether.
>
> This passed minimal IO testing.

Looks good...

I'll test with these patches and check if the problems I met
disappear.
