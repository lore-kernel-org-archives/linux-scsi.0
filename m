From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/3] zfcp: timer_setup() refactoring feature for v4.15-rc1
Date: Wed, 08 Nov 2017 18:29:02 -0500
Message-ID: <yq1vaikxsch.fsf@oracle.com>
References: <20171108141709.79074-1-maier@linux.vnet.ibm.com>
        <CAGXu5jJJPYY+BnvJsbwjN2OCJ9bBFPzb+92XFU8pYnDcRjWD_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jJJPYY+BnvJsbwjN2OCJ9bBFPzb+92XFU8pYnDcRjWD_g@mail.gmail.com>
        (Kees Cook's message of "Wed, 8 Nov 2017 10:59:50 -0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Steffen Maier <maier@linux.vnet.ibm.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org


Kees,

>> Kees Cook (1):
>>   zfcp: convert timers to use timer_setup()
>>
>> Steffen Maier (2):
>>   zfcp: purely mechanical update using timer API, plus blank lines
>>   zfcp: drop open coded assignments of timer_list.function
>
> These looks great, thanks!

These look good to me too.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
