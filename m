From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [RFC][PATCH] libata: enable SATA disk fua detection on default
Date: Wed, 04 Jul 2012 00:11:36 +0400
Message-ID: <4FF351F8.1000003@msgid.tls.msk.ru>
References: <1336447443-4685-1-git-send-email-wenqing.lz@taobao.com> <20120703090441.GA4804@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120703090441.GA4804@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
List-Id: linux-scsi@vger.kernel.org

On 03.07.2012 13:04, Zheng Liu wrote:
> Hi Jeff,
> 
> Sorry for bothering you.  Could you please review this patch, or give me
> some feedbacks.  If this patch can be applied, I can rebase it to the
> lastest version of mainline kernel.  Thank you.
[]
>> -int libata_fua = 0;
>> +int libata_fua = 1;

I guess it can be enabled after LOTS of testing of various drives out
there, which shows that no current drives have issues with FUA anymore,
and after building a black-list of devices which misbehave.  It is quite
a big project, I think.  But what it gives us in return?

(I've no idea if this is the right answer, speaking of myself only)

Thanks,

/mjt
