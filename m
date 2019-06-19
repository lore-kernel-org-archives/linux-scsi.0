From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 2/7] scsi: NCR5380: Always re-enable reselection interrupt
Date: Tue, 18 Jun 2019 20:47:54 -0400
Message-ID: <yq1wohixux1.fsf@oracle.com>
References: <cover.1560043151.git.fthain@telegraphics.com.au>
        <61f0c0f6aaf8fa96bf3dade5475615b2cfbc8846.1560043151.git.fthain@telegraphics.com.au>
        <58081aba-4e77-3c8e-847e-0698cf80e426@gmail.com>
        <alpine.LNX.2.21.1906111926330.25@nippy.intranet>
        <9c61076b-81f7-dc7b-0103-1e2e56072453@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <9c61076b-81f7-dc7b-0103-1e2e56072453@gmail.com> (Michael
        Schmitz's message of "Wed, 12 Jun 2019 11:46:59 +1200")
Sender: stable-owner@vger.kernel.org
To: Michael Schmitz <schmitzmic@gmail.com>
Cc: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Michael,

> No matter - patch applied cleanly to what I'm running on my Falcon,
> and works just fine for now (stresstest will take a few hours to
> complete). And that'll thoroughly exercise the reselection code path,
> from what we've seen before.

How did it go?

-- 
Martin K. Petersen	Oracle Linux Engineering
