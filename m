From: "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Subject: Re: [PATCH 2/3] drivers: scsi: remove unnecessary #ifdef MODULE
Date: Wed, 5 Jun 2019 23:22:34 +0000
Message-ID: <d377a82b-4269-e25d-2329-573db355877c@metux.net>
References: <1559397700-15585-1-git-send-email-info@metux.net>
 <1559397700-15585-3-git-send-email-info@metux.net>
 <AT5PR8401MB1169E817136F8B8587C7A716AB1A0@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AT5PR8401MB1169E817136F8B8587C7A716AB1A0@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Elliott, Robert (Servers)" <elliott@hpe.com>, "Enrico Weigelt, metux IT consult" <info@metux.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>, "jdelvare@suse.com" <jdelvare@suse.com>, "linux@roeck-us.net" <linux@roeck-us.net>, "khalid@gonehiking.org" <khalid@gonehiking.org>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "aacraid@microsemi.com" <aacraid@microsemi.com>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "linux-hwmon@vger.kernel.org" <linux-hwmon@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 01.06.19 15:40, Elliott, Robert (Servers) wrote:

<snip>

> I don't see any reply to James' comment that these changes result in

I've missed that mail :(

> static struct definitions that are unused, which should result in
> complaints by the compiler like:
>      warning: 'dptids' defined by not used [-Wunused-variable]

hmm, seems that const is missing on dptids ... I'll test that and
repost fixed vrsion.

--mtx

-- 
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
