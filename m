From: Ilias Tsitsimpis <iliastsi@arrikto.com>
Subject: Re: [PATCH] target/user: Fix possible overwrite of
 t_data_sg'slastiov[]
Date: Thu, 9 Mar 2017 17:54:14 +0200
Message-ID: <20170309155414.rg5gmyp66fyria7e@iliastsi-m.arr>
References: <1488260828-28167-1-git-send-email-lixiubo@cmss.chinamobile.com>
 <92ad7848-8d75-3344-eff6-b003599c55e9@redhat.com>
 <edee1773-74b5-d0e2-4b81-12cd75e55e52@cmss.chinamobile.com>
 <403e24b7-ecab-24e8-24cc-b9755b937c99@redhat.com>
 <20170309125112.a5xuyxl4acu3apga@iliastsi-m.arr>
 <208fcf11-17ab-4e23-a297-ef776f1ff743@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <208fcf11-17ab-4e23-a297-ef776f1ff743@email.android.com>
Sender: target-devel-owner@vger.kernel.org
To: =?utf-8?B?5p2O56eA5rOi?= <lixiubo@cmss.chinamobile.com>
Cc: AndyGrover <agrover@redhat.com>, nab@linux-iscsi.org, shli@kernel.org, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, namei.unix@gmail.com, mchristi@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 09, 2017 at 10:08PM, 李秀波 wrote:
> Any other advice about this change for your case?

I took a look at the patch you sent and it seems reasonable to me.
I didn't have the time to test it, but I will try to update to the
latest version (probably by next week) and report back.

Thanks for your work :)

-- 
Ilias
