From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC PATCH 1/2] fdomain: Resurrect fdomain and fdomain_cs drivers
Date: Mon, 08 Apr 2019 21:39:14 -0400
Message-ID: <yq1imvoot31.fsf@oracle.com>
References: <20190407185617.8467-1-linux@zary.sk>
        <20190407185617.8467-2-linux@zary.sk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190407185617.8467-2-linux@zary.sk> (Ondrej Zary's message of
        "Sun, 7 Apr 2019 20:56:16 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@zary.sk>
Cc: Rik Faith <faith@cs.unc.edu>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Hi Ondrej,

> This reverts commit e184f2bf4d9f1a3c612a8c1d67e73e9cf8ab5ab9.
> It does not compile but following patches will fix that.

I don't have any particular objections to reviving this driver if people
are actually using it. However, breaking bisection is going to be a
problem. So you'll have to squash the revert and the fixup patch and
carefully annotate the resolutions in the commit description.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
