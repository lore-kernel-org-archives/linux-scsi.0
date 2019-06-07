From: "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Subject: Re: [PATCH v2] drivers: scsi: remove unnecessary #ifdef MODULE
Date: Fri, 7 Jun 2019 23:50:55 +0200
Message-ID: <da4cea67-7651-7284-51e6-5313b1241a8a@metux.net>
References: <1559833471-30534-1-git-send-email-info@metux.net>
 <1559868089.3233.1.camel@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1559868089.3233.1.camel@linux.ibm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jejb@linux.ibm.com>, "Enrico Weigelt, metux IT consult" <info@metux.net>, linux-kernel@vger.kernel.org
Cc: khalid@gonehiking.org, martin.petersen@oracle.com, aacraid@microsemi.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07.06.19 02:41, James Bottomley wrote:
> On Thu, 2019-06-06 at 17:04 +0200, Enrico Weigelt, metux IT consult
> wrote:
>> From: Enrico Weigelt <info@metux.net>
>>
>> The MODULE_DEVICE_TABLE() macro already checks for MODULE defined,
>> so the extra check here is not necessary.
>>
>> Changes v2:
>>     * make dptids const to fix warning on unused variable
> 
> I don't think this works; in my version of gcc, const does not defeat
> the unused variable warning if I try with a test programme:
> 
> jejb@jarvis:~> gcc -Wunused-variable -c test1.c
> test1.c:3:18: warning: ‘i’ defined but not used [-Wunused-cons
> t-variable=]
>  static const int i[] = { 1, 2, 3};

Which gcc version are you using ?
Could you please have a try w/ the kernel (plus my patch) ?

Tested w/ 6.3.0-18+deb9u1 (stretch-amd64), got no warnings.


--mtx

-- 
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
