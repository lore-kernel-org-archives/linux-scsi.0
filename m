From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 0/4] scsi: qla2xxx: Convert timers to use timer_setup()
Date: Wed, 1 Nov 2017 11:46:41 -0700
Message-ID: <CAGXu5jJnB9rAN_qjrdh3iGfWtB2-p5dqNOtqScnSZn9j20iFgg@mail.gmail.com>
References: <1509477229-62141-1-git-send-email-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1509477229-62141-1-git-send-email-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Himanshu Madhani <Himanshu.Madhani@cavium.com>
Cc: Kees Cook <keescook@chromium.org>, Bart Van Assche <bart.vanassche@wdc.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 31, 2017 at 12:13 PM, Kees Cook <keescook@chromium.org> wrote:
> This breaks out the logical steps to convert the qla2xxx timers:
>
> 1) init_timer() -> setup_timer()
> 2) refactor qla2x00_start_timer() to not pass callback as argument
> 3) qla2x00_timer() to use timer_setup()
> 4) qla2x00_sp_timeout() to use timer_setup()
>
> The resulting diff is identical to the patch that appears to lock up
> the driver. This should help identify which step causes this behavior.

Hi, just curious if there's been any progress on debugging the issue
you saw with this series?

Thanks!

-Kees

-- 
Kees Cook
Pixel Security
