From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] [SCSI] mpt3sas: Fix secure erase premature termination (v4)
Date: Mon, 14 Nov 2016 18:30:20 -0500
Message-ID: <yq1twb9fxmb.fsf@sermon.lab.mkp.net>
References: <20161110135443.GA28767@kroah.com>
        <1478788527-7372-1-git-send-email-andrey2805@gmail.com>
        <yq1inrsk976.fsf@sermon.lab.mkp.net>
        <CAJphD_rAW+fmJq3dK8-a-fpDOdMcLk2t0dUGVUrowXFQ=jA08A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17475 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932174AbcKNXar (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Nov 2016 18:30:47 -0500
In-Reply-To: <CAJphD_rAW+fmJq3dK8-a-fpDOdMcLk2t0dUGVUrowXFQ=jA08A@mail.gmail.com>
        (Andrey Grodzovsky's message of "Sat, 12 Nov 2016 11:36:09 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrey Grodzovsky <andrey2805@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>, Igor Rybak <igor@media-clone.com>, Ezra Kohavi <ezra@media-clone.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>, Hannes Reinecke <hare@suse.de>, stable@vger.kernel.org

>>>>> "Andrey" == Andrey Grodzovsky <andrey2805@gmail.com> writes:

Andrey,

Andrey> Regarding older code where there is still a separate mpt2sas
Andrey> driver, should a separate patch to be done or this fix will be
Andrey> ported there ?

Feel free to submit a mpt2sas patch to the pre-4.4 stable trees.

-- 
Martin K. Petersen	Oracle Linux Engineering
