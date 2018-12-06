From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: t10-pi: Return correct ref tag when queue has no
 integrity profile
Date: Thu, 6 Dec 2018 12:04:29 +0000
Message-ID: <e8555cc6-1186-c5f9-ab8c-0c2ec90bae22@huawei.com>
References: <yq1ftvcsoes.fsf@oracle.com>
 <20181205023110.20162-1-martin.petersen@oracle.com>
 <2abe64a3-d54b-4cbb-bc56-1796e62fd0f9@acm.org> <yq1d0qgqdce.fsf@oracle.com>
 <4f705b13-84aa-b8bd-9c92-ab619a653f9c@acm.org> <yq1mupjp9v9.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <yq1mupjp9v9.fsf@oracle.com>
Sender: stable-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org, chenxiang <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

On 06/12/2018 04:17, Martin K. Petersen wrote:

+

>
> Bart,
>
>> Had you considered to use lower_32_bits() instead of "0xffffffff"?
>> That would to avoid that reviewers have to count the 'f'-s to verify
>> correctness of t10_pi_ref_tag().
>
> I hadn't. I guess I tend to think of lower_32_bits() as something you do
> to pointers, not to block numbers.
>

Xiang Chen tested the patch successfully. I'll let him provide tested-by 
tag.

Thanks,
John
