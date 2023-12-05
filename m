Received: from mail.nfschina.com (unknown [42.101.60.195])
	by lindbergh.monkeyblade.net (Postfix) with SMTP id DAFD99C;
	Tue,  5 Dec 2023 00:28:56 -0800 (PST)
Received: from [172.30.20.54] (unknown [180.167.10.98])
	by mail.nfschina.com (Maildata Gateway V2.8.8) with ESMTPSA id AAD5160626888;
	Tue,  5 Dec 2023 16:28:47 +0800 (CST)
Message-ID: <3d7307c5-0f93-9cef-0cef-34a4cc181d9b@nfschina.com>
Date: Tue, 5 Dec 2023 16:28:47 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2 0/3] scsi: aic7xxx: fix some problem of return value
Content-Language: en-US
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: hare@suse.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-janitors@vger.kernel.org
X-MD-Sfrom: suhui@nfschina.com
X-MD-SrcIP: 180.167.10.98
From: Su Hui <suhui@nfschina.com>
In-Reply-To: <8fb66471-9131-4990-a622-461f5735120f@suswa.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2023/12/5 16:14, Dan Carpenter wrote:
> On Tue, Dec 05, 2023 at 11:33:36AM +0800, Su Hui wrote:
>> On 2023/12/1 15:53, Dan Carpenter wrote:
>>> On Fri, Dec 01, 2023 at 10:59:53AM +0800, Su Hui wrote:
>>>> v2:
>>>>    - fix some problems and split v1 patch into this patch set.(Thanks to
>>>>      Dan)
>>>>
>>>> v1:
>>>>    - https://lore.kernel.org/all/20231130024122.1193324-1-suhui@nfschina.com/
>>>>
>>> Would have been better with Fixes tags probably.  Otherwise, it looks
>>> good to me.
>> Hi, Dan
>>
>> Sorry for the late reply.
>>
>> I'm not sure if it's worth to add Fixes tags.
>> These codes are very old which come from "Linux-2.6.12-rc2".
> I know some people use Fixes tags to point to Linux-2.6.12-rc2 but
> other people don't like it...  Or they didn't like it back in the day,
> I'm not sure now.
>
>> It's seems like a cleanup or improvement.
> It's definitely a Fix.  It affects runtime.
>
>> Umm, should I send v3 patches to add Fixes tags?
> I don't really care, I guess.  Probably yes?  Not a lot of people use
> aic7xxx these days so from a practical perspective it's not super
> important either way.

Got it.  Maybe it's right to omit these old Fixes tags.

Su Hui

