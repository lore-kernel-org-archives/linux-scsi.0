From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: t10-pi: Return correct ref tag when queue has no integrity profile
Date: Wed, 05 Dec 2018 23:17:14 -0500
Message-ID: <yq1mupjp9v9.fsf@oracle.com>
References: <yq1ftvcsoes.fsf@oracle.com>
        <20181205023110.20162-1-martin.petersen@oracle.com>
        <2abe64a3-d54b-4cbb-bc56-1796e62fd0f9@acm.org>
        <yq1d0qgqdce.fsf@oracle.com>
        <4f705b13-84aa-b8bd-9c92-ab619a653f9c@acm.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <4f705b13-84aa-b8bd-9c92-ab619a653f9c@acm.org> (Bart Van Assche's
        message of "Wed, 5 Dec 2018 07:00:58 -0800")
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, john.garry@huawei.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Bart,

> Had you considered to use lower_32_bits() instead of "0xffffffff"?
> That would to avoid that reviewers have to count the 'f'-s to verify
> correctness of t10_pi_ref_tag().

I hadn't. I guess I tend to think of lower_32_bits() as something you do
to pointers, not to block numbers.

-- 
Martin K. Petersen	Oracle Linux Engineering
