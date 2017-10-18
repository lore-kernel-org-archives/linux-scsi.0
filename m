From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: gdth: Convert timers to use timer_setup()
Date: Tue, 17 Oct 2017 23:06:28 -0400
Message-ID: <yq1zi8ptarv.fsf@oracle.com>
References: <20171016235502.GA102608@beast> <yq1a80qxvn6.fsf@oracle.com>
        <CAGXu5jLgOxkUmMuN97er4rzZfD3CSUNy=TXA15WhVA14NHV75Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jLgOxkUmMuN97er4rzZfD3CSUNy=TXA15WhVA14NHV75Q@mail.gmail.com>
        (Kees Cook's message of "Tue, 17 Oct 2017 07:53:05 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Achim Leubner <achim_leubner@adaptec.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Kees,

> Thanks for the reviews! Do you want the timer tree to carry these
> patches, or can you pick them up in the scsi tree?

Up to you. I'm not going to rebase my 4.15 queue this late in the cycle
so the patches would end up going in at the end of the merge window. If
you prefer to have them hit the first pull you should queue them up in
the timer tree.

-- 
Martin K. Petersen	Oracle Linux Engineering
