From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: t10-pi: Return correct ref tag when queue has no integrity profile
Date: Wed, 05 Dec 2018 09:04:33 -0500
Message-ID: <yq1d0qgqdce.fsf@oracle.com>
References: <yq1ftvcsoes.fsf@oracle.com>
        <20181205023110.20162-1-martin.petersen@oracle.com>
        <2abe64a3-d54b-4cbb-bc56-1796e62fd0f9@acm.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <2abe64a3-d54b-4cbb-bc56-1796e62fd0f9@acm.org> (Bart Van Assche's
        message of "Tue, 4 Dec 2018 20:24:32 -0800")
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, john.garry@huawei.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Hi Bart,

> Since the return value of this function is 'u32', can the ' &
> 0xffffffff' be left out?

Absolutely, and I almost zapped it. However, I decided to leave it to
emphasize the point that the reference tag is truncated to a 32-bit
value. To me, this is more obvious than having to backtrack and spot the
u32 in the function definition. I generally appreciate some sort of
commentary around a return statement if the value deviates from the
ordinary.

The parentheses around the shift value irk me but had to leave those in
place to silence gcc.

-- 
Martin K. Petersen	Oracle Linux Engineering
