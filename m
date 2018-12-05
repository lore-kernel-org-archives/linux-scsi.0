From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi: t10-pi: Return correct ref tag when queue has no
 integrity profile
Date: Wed, 5 Dec 2018 07:00:58 -0800
Message-ID: <4f705b13-84aa-b8bd-9c92-ab619a653f9c@acm.org>
References: <yq1ftvcsoes.fsf@oracle.com>
 <20181205023110.20162-1-martin.petersen@oracle.com>
 <2abe64a3-d54b-4cbb-bc56-1796e62fd0f9@acm.org> <yq1d0qgqdce.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <yq1d0qgqdce.fsf@oracle.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, john.garry@huawei.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/5/18 6:04 AM, Martin K. Petersen wrote:
>> Since the return value of this function is 'u32', can the ' &
>> 0xffffffff' be left out?
> 
> Absolutely, and I almost zapped it. However, I decided to leave it to
> emphasize the point that the reference tag is truncated to a 32-bit
> value. To me, this is more obvious than having to backtrack and spot the
> u32 in the function definition. I generally appreciate some sort of
> commentary around a return statement if the value deviates from the
> ordinary.
> 
> The parentheses around the shift value irk me but had to leave those in
> place to silence gcc.

Hi Martin,

Had you considered to use lower_32_bits() instead of "0xffffffff"? That 
would to avoid that reviewers have to count the 'f'-s to verify 
correctness of t10_pi_ref_tag().

Thanks,

Bart.
