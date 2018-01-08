From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] scsi: mptfusion: use strlcpy() instead of strncpy()
Date: Mon, 8 Jan 2018 17:43:02 +0100
Message-ID: <CAK8P3a2dF8NYPObQJwUpOmkpcPMQBanyqwxZz_oqPCKEW2Q_jw@mail.gmail.com>
References: <1515415753-10534-1-git-send-email-wangxiongfeng2@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1515415753-10534-1-git-send-email-wangxiongfeng2@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 8, 2018 at 1:49 PM, Xiongfeng Wang
<wangxiongfeng2@huawei.com> wrote:
> From: Xiongfeng Wang <xiongfeng.wang@linaro.org>
>
> gcc-8 reports
>
> drivers/message/fusion/mptbase.c: In function 'mpt_display_event_info':
> ./include/linux/string.h:245:9: warning: '__builtin_strncpy' specified
> bound 100 equals destination size [-Wstringop-truncation]
>
> We need to use strlcpy() to make sure the dest string is
> nul-terminated.
>
> Signed-off-by: Xiongfeng Wang <xiongfeng.wang@linaro.org>

Looks correct to me,

Acked-by: Arnd Bergmann <arnd@arndb.de>
