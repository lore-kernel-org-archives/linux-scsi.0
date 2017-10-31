From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] target/iscsi: Convert timers to use timer_setup()
Date: Tue, 31 Oct 2017 13:42:12 -0400
Message-ID: <yq1k1zb8b9n.fsf@oracle.com>
References: <20171027091930.GA14728@beast> <1509109031.3135.1.camel@wdc.com>
        <CAGXu5j+z9t28n33e6r9hxRNX1hpkzF4Z5sy308sWYh84whkRfQ@mail.gmail.com>
        <1509470185.12927.1.camel@wdc.com> <yq11slj9qtq.fsf@oracle.com>
        <1509471239.12927.3.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1509471239.12927.3.camel@wdc.com> (Bart Van Assche's message of
        "Tue, 31 Oct 2017 17:34:00 +0000")
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "keescook@chromium.org" <keescook@chromium.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "varun@chelsio.com" <varun@chelsio.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "jiangyilism@gmail.com" <jiangyilism@gmail.com>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org


Bart,

> The tree I tested indeed includes that rebased patch. BTW, since the code
> touched by that patch has not been modified in the past months, the rebased
> patch is identical to the patch I posted in May 2017.

OK. Just checking.

So what's the plan here? Should both patches be routed through the timer
tree?

-- 
Martin K. Petersen	Oracle Linux Engineering
