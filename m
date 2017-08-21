From: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Subject: Re: [PATCH v3 01/13] mpt3sas: Update MPI Header
Date: Mon, 21 Aug 2017 11:24:25 +0530
Message-ID: <CA+RiK65oFXv7c8qDo0Yx2tkgvBNAe8vynZP4Hfh3m4shWiv+Dg@mail.gmail.com>
References: <1502183035-7441-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1502183035-7441-2-git-send-email-suganath-prabu.subramani@broadcom.com> <1502227097.5880.3.camel@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f181.google.com ([209.85.128.181]:35816 "EHLO
        mail-wr0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750937AbdHUFy2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Aug 2017 01:54:28 -0400
Received: by mail-wr0-f181.google.com with SMTP id k46so14347984wre.2
        for <linux-scsi@vger.kernel.org>; Sun, 20 Aug 2017 22:54:27 -0700 (PDT)
In-Reply-To: <1502227097.5880.3.camel@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: J Freyensee <james_p_freyensee@linux.intel.com>
Cc: "JBottomley@Parallels.com" <JBottomley@parallels.com>, jejb@kernel.org, Christoph Hellwig <hch@infradead.org>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Sathya Prakash <Sathya.Prakash@broadcom.com>, Chaitra Basappa <chaitra.basappa@broadcom.com>, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, Kashyap Desai <kashyap.desai@broadcom.com>

Hi James,
we have fixed the sparse warnings associated with this patch set and
posting V4 of mpt3sas patches soon. We are also working on sparse
error/warnings that existed before this patch set and we ll be posting
it separately.

Thanks,
Suganath Prabu S

On Wed, Aug 9, 2017 at 2:48 AM, J Freyensee
<james_p_freyensee@linux.intel.com> wrote:
>
>
> Looks like your header has a white space error:
>
> Applying: mpt3sas: Update MPI Header
> .git/rebase-apply/patch:1452: new blank line at EOF.
> +
>
> Also, FYI, this project has a lot of sparse errors that look like existed
> before your patchset.  As your patchset touches a few of the files that
> have sparse warnings (such as mpt3sas_base.c, mpt3sas_scsih.c, etc), maybe
> you'll want to investigate fixing these things?
>
>
> [mainline-linux]$ make C=1
>   CHK     include/config/kernel.release
>   CHK     include/generated/uapi/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CHK     include/generated/bounds.h
>   CHK     include/generated/timeconst.h
>   CHK     include/generated/asm-offsets.h
>   CALL    scripts/checksyscalls.sh
>   CHK     scripts/mod/devicetable-offsets.h
>   CHK     include/generated/compile.h
>   AR      drivers/scsi/mpt3sas/built-in.o
>   CHECK   drivers/scsi/mpt3sas/mpt3sas_base.c
> drivers/scsi/mpt3sas/mpt3sas_base.c:861:42: warning: incorrect type in
> assignment (different base types)
> drivers/scsi/mpt3sas/mpt3sas_base.c:861:42:    expected unsigned short
> [unsigned] [usertype] Event
> drivers/scsi/mpt3sas/mpt3sas_base.c:861:42:    got restricted __le16
> [usertype] Event
> drivers/scsi/mpt3sas/mpt3sas_base.c:862:49: warning: incorrect type in
> assignment (different base types)
> drivers/scsi/mpt3sas/mpt3sas_base.c:862:49:    expected unsigned int
> [unsigned] [usertype] EventContext
> drivers/scsi/mpt3sas/mpt3sas_base.c:862:49:    got restricted __le32
> [usertype] EventContext
> drivers/scsi/mpt3sas/mpt3sas_base.c:1080:64: warning: incorrect type in
> argument 2 (different address spaces)
> drivers/scsi/mpt3sas/mpt3sas_base.c:1080:64:    expected void volatile
> [noderef] <asn:2>*addr
> drivers/scsi/mpt3sas/mpt3sas_base.c:1080:64:    got unsigned long long
> [usertype] *<noident>
> drivers/scsi/mpt3sas/mpt3sas_base.c:1129:52: warning: incorrect type in
> argument 2 (different address spaces)
> drivers/scsi/mpt3sas/mpt3sas_base.c:1129:52:    expected void volatile
> [noderef] <asn:2>*addr
> drivers/scsi/mpt3sas/mpt3sas_base.c:1129:52:    got unsigned long long
> [usertype] *<noident>
> drivers/scsi/mpt3sas/mpt3sas_base.c:1519:36: warning: incorrect type in
> assignment (different base types)
> drivers/scsi/mpt3sas/mpt3sas_base.c:1519:36:    expected unsigned long long
> [unsigned] [long] [long long] [usertype] <noident>
> drivers/scsi/mpt3sas/mpt3sas_base.c:1519:36:    got restricted __le64
> [usertype] <noident>
> drivers/scsi/mpt3sas/mpt3sas_base.c:1532:37: warning: incorrect type in
> assignment (different base types)
> drivers/scsi/mpt3sas/mpt3sas_base.c:1532:37:    expected unsigned long long
> [unsigned] [long] [long long] [usertype] <noident>
> drivers/scsi/mpt3sas/mpt3sas_base.c:1532:37:    got restricted __le64
> [usertype] <noident>
> drivers/scsi/mpt3sas/mpt3sas_base.c:1552:45: warning: incorrect type in
> assignment (different base types)
> drivers/scsi/mpt3sas/mpt3sas_base.c:1552:45:    expected unsigned long long
> [unsigned] [long] [long long] [usertype] <noident>
> drivers/scsi/mpt3sas/mpt3sas_base.c:1552:45:    got restricted __le64
> [usertype] <noident>
> drivers/scsi/mpt3sas/mpt3sas_base.c:1565:45: warning: incorrect type in
> assignment (different base types)
> drivers/scsi/mpt3sas/mpt3sas_base.c:1565:45:    expected unsigned long long
> [unsigned] [long] [long long] [usertype] <noident>
> drivers/scsi/mpt3sas/mpt3sas_base.c:1565:45:    got restricted __le64
> [usertype] <noident>
> drivers/scsi/mpt3sas/mpt3sas_base.c:1575:36: warning: incorrect type in
> assignment (different base types)
> drivers/scsi/mpt3sas/mpt3sas_base.c:1575:36:    expected unsigned long long
> [unsigned] [long] [long long] [usertype] <noident>
> drivers/scsi/mpt3sas/mpt3sas_base.c:1575:36:    got restricted __le64
> [usertype] <noident>
> drivers/scsi/mpt3sas/mpt3sas_base.c:1594:5: warning: symbol 'base_mod64'
> was not declared. Should it be static?
> drivers/scsi/mpt3sas/mpt3sas_base.c:1717:36: warning: incorrect type in
> assignment (different base types)
> drivers/scsi/mpt3sas/mpt3sas_base.c:1717:36:    expected unsigned long long
> [unsigned] [long] [long long] [usertype] <noident>
> drivers/scsi/mpt3sas/mpt3sas_base.c:1717:36:    got restricted __le64
> [usertype] <noident>
> drivers/scsi/mpt3sas/mpt3sas_base.c:1722:28: warning: incorrect type in
> assignment (different base types)
> drivers/scsi/mpt3sas/mpt3sas_base.c:1722:28:    expected unsigned long long
> [unsigned] [long] [long long] [usertype] <noident>
> drivers/scsi/mpt3sas/mpt3sas_base.c:1722:28:    got restricted __le64
> [usertype] <noident>
> drivers/scsi/mpt3sas/mpt3sas_base.c:1620:1: warning: symbol
> 'base_make_prp_nvme' was not declared. Should it be static?
> drivers/scsi/mpt3sas/mpt3sas_base.c:1761:21: warning: incorrect type in
> assignment (different base types)
> drivers/scsi/mpt3sas/mpt3sas_base.c:1761:21:    expected unsigned int
> [unsigned] [usertype] data_length
> drivers/scsi/mpt3sas/mpt3sas_base.c:1761:21:    got restricted __le32
> [usertype] <noident>
> drivers/scsi/mpt3sas/mpt3sas_base.c:2771:32: warning: cast removes address
> space of expression
> drivers/scsi/mpt3sas/mpt3sas_base.c:3064:16: warning: incorrect type in
> argument 1 (different base types)
> drivers/scsi/mpt3sas/mpt3sas_base.c:3064:16:    expected unsigned long
> [unsigned] val
> drivers/scsi/mpt3sas/mpt3sas_base.c:3064:16:    got restricted __le64
> [usertype] <noident>
> drivers/scsi/mpt3sas/mpt3sas_base.c:3064:16: warning: incorrect type in
> argument 1 (different base types)
> drivers/scsi/mpt3sas/mpt3sas_base.c:3064:16:    expected unsigned long
> [unsigned] val
> drivers/scsi/mpt3sas/mpt3sas_base.c:3064:16:    got restricted __le64
> [usertype] <noident>
> drivers/scsi/mpt3sas/mpt3sas_base.c:3064:16: warning: incorrect type in
> argument 1 (different base types)
> drivers/scsi/mpt3sas/mpt3sas_base.c:3064:16:    expected unsigned long
> [unsigned] val
> drivers/scsi/mpt3sas/mpt3sas_base.c:3064:16:    got restricted __le64
> [usertype] <noident>
> drivers/scsi/mpt3sas/mpt3sas_base.c:3064:16: warning: incorrect type in
> argument 1 (different base types)
> drivers/scsi/mpt3sas/mpt3sas_base.c:3064:16:    expected unsigned long
> [unsigned] val
> drivers/scsi/mpt3sas/mpt3sas_base.c:3064:16:    got restricted __le64
> [usertype] <noident>
> drivers/scsi/mpt3sas/mpt3sas_base.c:3064:16: warning: incorrect type in
> argument 1 (different base types)
> drivers/scsi/mpt3sas/mpt3sas_base.c:3064:16:    expected unsigned long
> [unsigned] val
> drivers/scsi/mpt3sas/mpt3sas_base.c:3064:16:    got restricted __le64
> [usertype] <noident>
> drivers/scsi/mpt3sas/mpt3sas_base.c:3219:16: warning: incorrect type in
> argument 1 (different base types)
> drivers/scsi/mpt3sas/mpt3sas_base.c:3219:16:    expected unsigned int
> [unsigned] val
> drivers/scsi/mpt3sas/mpt3sas_base.c:3219:16:    got restricted __le32
> [usertype] <noident>
> drivers/scsi/mpt3sas/mpt3sas_base.c:3241:16: warning: incorrect type in
> argument 1 (different base types)
> drivers/scsi/mpt3sas/mpt3sas_base.c:3241:16:    expected unsigned int
> [unsigned] val
> drivers/scsi/mpt3sas/mpt3sas_base.c:3241:16:    got restricted __le32
> [usertype] <noident>
> drivers/scsi/mpt3sas/mpt3sas_base.c:3264:16: warning: incorrect type in
> argument 1 (different base types)
> drivers/scsi/mpt3sas/mpt3sas_base.c:3264:16:    expected unsigned int
> [unsigned] val
> drivers/scsi/mpt3sas/mpt3sas_base.c:3264:16:    got restricted __le32
> [usertype] <noident>
> drivers/scsi/mpt3sas/mpt3sas_base.c:3285:16: warning: incorrect type in
> argument 1 (different base types)
> drivers/scsi/mpt3sas/mpt3sas_base.c:3285:16:    expected unsigned int
> [unsigned] val
> drivers/scsi/mpt3sas/mpt3sas_base.c:3285:16:    got restricted __le32
> [usertype] <noident>
> drivers/scsi/mpt3sas/mpt3sas_base.c:3306:16: warning: incorrect type in
> argument 1 (different base types)
> drivers/scsi/mpt3sas/mpt3sas_base.c:3306:16:    expected unsigned int
> [unsigned] val
> drivers/scsi/mpt3sas/mpt3sas_base.c:3306:16:    got restricted __le32
> [usertype] <noident>
> drivers/scsi/mpt3sas/mpt3sas_base.c:4746:24: warning: incorrect type in
> argument 1 (different base types)
> drivers/scsi/mpt3sas/mpt3sas_base.c:4746:24:    expected unsigned int
> [unsigned] val
> drivers/scsi/mpt3sas/mpt3sas_base.c:4746:24:    got restricted __le32
> [usertype] <noident>
> drivers/scsi/mpt3sas/mpt3sas_base.c:4767:20: warning: cast to restricted
> __le16
> drivers/scsi/mpt3sas/mpt3sas_base.c:4776:20: warning: cast to restricted
> __le16
> drivers/scsi/mpt3sas/mpt3sas_base.c:4790:36: warning: cast to restricted
> __le16
> drivers/scsi/mpt3sas/mpt3sas_base.c:5971:55: warning: incorrect type in
> argument 2 (different address spaces)
> drivers/scsi/mpt3sas/mpt3sas_base.c:5971:55:    expected void volatile
> [noderef] <asn:2>*addr
> drivers/scsi/mpt3sas/mpt3sas_base.c:5971:55:    got unsigned long long
> [usertype] *<noident>
>   CC [M]  drivers/scsi/mpt3sas/mpt3sas_base.o
>   CHECK   drivers/scsi/mpt3sas/mpt3sas_config.c
>   CC [M]  drivers/scsi/mpt3sas/mpt3sas_config.o
>   CHECK   drivers/scsi/mpt3sas/mpt3sas_scsih.c
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:7066:13: warning: cast to restricted
> __le16
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:7066:13: warning: cast from restricted
> __le32
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:160:22: warning: symbol
> 'mpt3sas_raid_template' was not declared. Should it be static?
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:161:22: warning: symbol
> 'mpt2sas_raid_template' was not declared. Should it be static?
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:603:21: warning: symbol
> 'mpt3sas_get_pdev_from_target' was not declared. Should it be static?
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:911:21: warning: symbol
> '__mpt3sas_get_pdev_by_wwid' was not declared. Should it be static?
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:944:21: warning: symbol
> 'mpt3sas_get_pdev_by_wwid' was not declared. Should it be static?
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:958:21: warning: symbol
> '__mpt3sas_get_pdev_by_idchannel' was not declared. Should it be static?
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:994:21: warning: symbol
> 'mpt3sas_get_pdev_by_idchannel' was not declared. Should it be static?
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:1008:21: warning: symbol
> '__mpt3sas_get_pdev_by_handle' was not declared. Should it be static?
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:3897:36: warning: incorrect type in
> assignment (different base types)
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:3897:36:    expected unsigned short
> [unsigned] [usertype] handle
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:3897:36:    got restricted __le16
> [usertype] DevHandle
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:4090:9: warning: cast to restricted
> __le16
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:4097:28: warning: incorrect type in
> assignment (different base types)
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:4097:28:    expected restricted __le16
> [usertype] Event
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:4097:28:    got unsigned short
> [unsigned] [usertype] event
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:4098:35: warning: incorrect type in
> assignment (different base types)
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:4098:35:    expected restricted __le32
> [usertype] EventContext
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:4098:35:    got unsigned int
> [unsigned] [usertype] event_context
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:4149:9: warning: cast to restricted
> __le16
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:4157:32: warning: incorrect type in
> assignment (different base types)
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:4157:32:    expected restricted __le16
> [usertype] DevHandle
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:4157:32:    got unsigned short
> [unsigned] [usertype] handle
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:4677:61: warning: incorrect type in
> assignment (different base types)
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:4677:61:    expected restricted __le32
> [usertype] PrimaryReferenceTag
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:4677:61:    got restricted __be32
> [usertype] <noident>
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8511:63: warning: restricted __le64
> degrades to integer
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8512:60: warning: restricted __le16
> degrades to integer
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8536:43: warning: restricted __le16
> degrades to integer
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8547:65: warning: restricted __le16
> degrades to integer
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8551:44: warning: incorrect type in
> assignment (different base types)
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8551:44:    expected unsigned short
> [unsigned] [usertype] handle
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8551:44:    got restricted __le16
> [usertype] DevHandle
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8553:62: warning: incorrect type in
> assignment (different base types)
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8553:62:    expected unsigned short
> [unsigned] [usertype] handle
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8553:62:    got restricted __le16
> [usertype] DevHandle
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8593:51: warning: incorrect type in
> assignment (different base types)
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8593:51:    expected restricted __le16
> [addressable] [usertype] DevHandle
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8593:51:    got unsigned short
> [unsigned] [usertype] <noident>
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8598:43: warning: incorrect type in
> assignment (different base types)
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8598:43:    expected restricted __le64
> [addressable] [usertype] SASAddress
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8598:43:    got unsigned long long
> [unsigned] [usertype] <noident>
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8600:37: warning: incorrect type in
> assignment (different base types)
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8600:37:    expected restricted __le16
> [addressable] [usertype] Slot
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8600:37:    got unsigned short
> [unsigned] [usertype] <noident>
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8601:38: warning: incorrect type in
> assignment (different base types)
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8601:38:    expected restricted __le16
> [addressable] [usertype] Flags
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8601:38:    got unsigned short
> [unsigned] [usertype] <noident>
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8631:58: warning: restricted __le64
> degrades to integer
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8632:58: warning: restricted __le16
> degrades to integer
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8667:67: warning: restricted __le16
> degrades to integer
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8671:45: warning: incorrect type in
> assignment (different base types)
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8671:45:    expected unsigned short
> [unsigned] [usertype] handle
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8671:45:    got restricted __le16
> [usertype] DevHandle
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8673:62: warning: incorrect type in
> assignment (different base types)
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8673:62:    expected unsigned short
> [unsigned] [usertype] handle
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8673:62:    got restricted __le16
> [usertype] DevHandle
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8723:38: warning: incorrect type in
> assignment (different base types)
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8723:38:    expected restricted __le64
> [addressable] [usertype] WWID
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8723:38:    got unsigned long long
> [unsigned] [usertype] <noident>
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8724:38: warning: incorrect type in
> assignment (different base types)
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8724:38:    expected restricted __le16
> [addressable] [usertype] Slot
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8724:38:    got unsigned short
> [unsigned] [usertype] <noident>
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8725:39: warning: incorrect type in
> assignment (different base types)
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8725:39:    expected restricted __le32
> [addressable] [usertype] Flags
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8725:39:    got unsigned int
> [unsigned] [usertype] <noident>
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8726:43: warning: incorrect type in
> assignment (different base types)
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8726:43:    expected restricted __le16
> [addressable] [usertype] DevHandle
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8726:43:    got unsigned short
> [unsigned] [assigned] [usertype] handle
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:9629:25: warning: cast to restricted
> __le32
>   CC [M]  drivers/scsi/mpt3sas/mpt3sas_scsih.o
>   CHECK   drivers/scsi/mpt3sas/mpt3sas_transport.c
>   CC [M]  drivers/scsi/mpt3sas/mpt3sas_transport.o
>   CHECK   drivers/scsi/mpt3sas/mpt3sas_ctl.c
> drivers/scsi/mpt3sas/mpt3sas_ctl.c:814:21: warning: constant
> 0xFFFFFFFF00000000 is so big it is unsigned long
> drivers/scsi/mpt3sas/mpt3sas_ctl.c:299:30: warning: cast to restricted
> __le32
> drivers/scsi/mpt3sas/mpt3sas_ctl.c:299:30: warning: cast from restricted
> __le16
> drivers/scsi/mpt3sas/mpt3sas_ctl.c:813:62: warning: incorrect type in
> assignment (different base types)
> drivers/scsi/mpt3sas/mpt3sas_ctl.c:813:62:    expected restricted __le64
> [usertype] ErrorResponseBaseAddress
> drivers/scsi/mpt3sas/mpt3sas_ctl.c:813:62:    got unsigned long long
> drivers/scsi/mpt3sas/mpt3sas_ctl.c:816:22: warning: cast to restricted
> __le64
> drivers/scsi/mpt3sas/mpt3sas_ctl.c:816:22: warning: cast from restricted
> __le32
> drivers/scsi/mpt3sas/mpt3sas_ctl.c:817:67: warning: incorrect type in
> assignment (different base types)
> drivers/scsi/mpt3sas/mpt3sas_ctl.c:817:67:    expected restricted __le16
> [usertype] ErrorResponseAllocationLength
> drivers/scsi/mpt3sas/mpt3sas_ctl.c:817:67:    got int
>   CC [M]  drivers/scsi/mpt3sas/mpt3sas_ctl.o
>   CHECK   drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
>   CC [M]  drivers/scsi/mpt3sas/mpt3sas_trigger_diag.o
>   CHECK   drivers/scsi/mpt3sas/mpt3sas_warpdrive.c
> drivers/scsi/mpt3sas/mpt3sas_warpdrive.c:180:27: warning: restricted __le16
> degrades to integer
>   CC [M]  drivers/scsi/mpt3sas/mpt3sas_warpdrive.o
>   LD [M]  drivers/scsi/mpt3sas/mpt3sas.o
>   LD      arch/x86/boot/compressed/vmlinux
>
>
