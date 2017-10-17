From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] scsi: gdth: Convert timers to use timer_setup()
Date: Tue, 17 Oct 2017 07:53:05 -0700
Message-ID: <CAGXu5jLgOxkUmMuN97er4rzZfD3CSUNy=TXA15WhVA14NHV75Q@mail.gmail.com>
References: <20171016235502.GA102608@beast> <yq1a80qxvn6.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1a80qxvn6.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Achim Leubner <achim_leubner@adaptec.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 16, 2017 at 9:09 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> Kees,
>
>> In preparation for unconditionally passing the struct timer_list
>> pointer to all timer callbacks, switch to using the new timer_setup()
>> and from_timer() to pass the timer pointer explicitly.
>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

Thanks for the reviews! Do you want the timer tree to carry these
patches, or can you pick them up in the scsi tree?

-Kees

-- 
Kees Cook
Pixel Security
