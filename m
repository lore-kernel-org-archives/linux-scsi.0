From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 00/14] mpt3sas driver NVMe support:
Date: Mon, 25 Sep 2017 16:22:21 -0400
Message-ID: <yq1o9pyfs02.fsf@oracle.com>
References: <1503322344-5900-1-git-send-email-suganath-prabu.subramani@broadcom.com>
        <yq1lgmbauxt.fsf@oracle.com>
        <CA+RiK65F0CUNkc7AXN7n-rwvmf=Xm-t6dNvG134hY9yapwgDYg@mail.gmail.com>
        <yq1a82gxwqm.fsf@oracle.com>
        <CA+RiK67f59U5Ss_Z2=veBRODtBSp1-4VTbosLkHkgaxY9XA6hQ@mail.gmail.com>
        <yq13787w1a3.fsf@oracle.com>
        <CA+RiK667V9nDEr7RywED2_RoSq97m511HZTpGqPbij9-=vADvQ@mail.gmail.com>
        <CA+RiK64sJZzTcTHODHj0monB2_0xKAkvjrC79rGv2mNUPO87-A@mail.gmail.com>
        <yq1wp50rcqw.fsf@oracle.com>
        <CA+RiK65GPnfqpQAuUWEs_NdW9crumkGparCqynN_dBti8BPXqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+RiK65GPnfqpQAuUWEs_NdW9crumkGparCqynN_dBti8BPXqQ@mail.gmail.com>
        (Suganath Prabu Subramani's message of "Mon, 18 Sep 2017 16:09:09
        +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Sathya Prakash <Sathya.Prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, linux-kernel@vger.kernel.org, Chaitra Basappa <chaitra.basappa@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, linux-nvme@lists.infradead.org, Jayant Daftardar <jayant.daftardar@broadcom.com>
List-Id: linux-scsi@vger.kernel.org


Hi Suganath,

> Also, Making all PRP buffer may or may not need FW changes (assuming
> it is possible.), we may end up into multiple FW version check.

I don't understand how submitting an I/O that is guaranteed to honor the
constraints of the target NVMe drive could possibly cause problems for
the controller firmware. Quite the contrary, it's the best case
scenario.

> Since this is main IO path and current driver is following H/W
> limitation, we should avoid any changes in this area until and unless
> change is universal acceptable in FW (for all type of work load).

This is why you need to involve the Linux community early in the design
process and not when your implementation is complete.

We could have told you right away what the correct approach would be for
your Linux driver. And that said approach works for products from other
vendors so we see no compelling reason to deviate from it.

As evidenced by Broadcom disowning the legacy mpt and megaraid drivers,
I will be stuck maintaining this mpt3sas code for a decade or more. Long
after Broadcom has ended official support and moved on to different
ASICs and programming interfaces. Consequently, I am very heavily biased
towards solutions that leverage the shared interfaces provided by the
kernel and that don't have special cases and workarounds inside the
driver.

-- 
Martin K. Petersen	Oracle Linux Engineering
