From: James Smart <james.smart@emulex.com>
Subject: Re: [PATCH 0/2] SCSI-lpfc: Deletion of an unnecessary check
Date: Mon, 16 Feb 2015 10:58:37 -0500
Message-ID: <54E213AD.2080902@emulex.com>
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.so
 urceforge.net> <54D3EDDB.1050905@users.sourceforge.net>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <54D3EDDB.1050905@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: "James E. J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

Markus,

Suggestions noted. If not merged, I'll pull them into the next patch set.

-- james


Acked-By: James Smart  <james.smart@emulex.com>


On 2/5/2015 5:25 PM, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Thu, 5 Feb 2015 23:17:52 +0100
>
> Another update suggestion was taken into account after a patch was applied
> from static source code analysis.
>
> Markus Elfring (2):
>    Delete an unnecessary check before the function call "kfree"
>    One function call less in lpfc_bsg_hba_set_event() after error detection
>
>   drivers/scsi/lpfc/lpfc_bsg.c | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
>

