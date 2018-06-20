From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3] target: fix truncated PR-in ReadKeys response
Date: Tue, 19 Jun 2018 21:37:35 -0400
Message-ID: <yq1d0wmfdb4.fsf@oracle.com>
References: <20180619140216.23077c60@suse.de>
        <20180619155824.15388-1-ddiss@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180619155824.15388-1-ddiss@suse.de> (David Disseldorp's
        message of "Tue, 19 Jun 2018 17:58:24 +0200")
Sender: stable-owner@vger.kernel.org
To: David Disseldorp <ddiss@suse.de>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


David,

> SPC5r17 states that the contents of the ADDITIONAL LENGTH field are not
> altered based on the allocation length, so always calculate and pack the
> full key list length even if the list itself is truncated.
>
> According to Maged:
>   Yes it fixes the "Storage Spaces Persistent Reservation" test in the
>   Windows 2016 Server Failover Cluster validation suites when having
>   many connections that result in more than 8 registrations. I tested
>   your patch on 4.17 with iblock.
>
> This behaviour can be tested using the libiscsi PrinReadKeys.Truncate
> test.

Applied to 4.18/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
