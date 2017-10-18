From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] scsi: gdth: Convert timers to use timer_setup()
Date: Tue, 17 Oct 2017 20:15:19 -0700
Message-ID: <CAGXu5jKG3oHG36mRQ0Wn07nRK=eGW7cV-UEujooA3AVMybndtw@mail.gmail.com>
References: <20171016235502.GA102608@beast> <yq1a80qxvn6.fsf@oracle.com>
 <CAGXu5jLgOxkUmMuN97er4rzZfD3CSUNy=TXA15WhVA14NHV75Q@mail.gmail.com> <yq1zi8ptarv.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1zi8ptarv.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 17, 2017 at 8:06 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> Kees,
>
>> Thanks for the reviews! Do you want the timer tree to carry these
>> patches, or can you pick them up in the scsi tree?
>
> Up to you. I'm not going to rebase my 4.15 queue this late in the cycle
> so the patches would end up going in at the end of the merge window. If
> you prefer to have them hit the first pull you should queue them up in
> the timer tree.

Okay, thanks, I'll take them via the timer tree.

-Kees

-- 
Kees Cook
Pixel Security
