From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: out of range LBA using sg_raw
Date: Wed, 08 Mar 2017 19:40:30 -0500
Message-ID: <yq1d1dr1dvl.fsf@oracle.com>
References: <cf343e80707394b8945cd7643f7beecd@mail.gmail.com>
        <20170308151113.GB27450@infradead.org>
        <eb88925faa247b2ae6e510fc7fd0cff9@mail.gmail.com>
        <yq1y3wfhgpn.fsf@oracle.com>
        <07493b3c3da0b19a9fa96899cad640f3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <07493b3c3da0b19a9fa96899cad640f3@mail.gmail.com> (Kashyap
        Desai's message of "Wed, 8 Mar 2017 22:19:58 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Kashyap" == Kashyap Desai <kashyap.desai@broadcom.com> writes:

Kashyap,

Kashyap> Agree on this point. I am planning to study all possible such
Kashyap> sanity in driver for VD and not trying to fix one specific
Kashyap> scenario as described here.  Do you think fix in this area is
Kashyap> good for kernel-stable as well OR just keep in linux-next as it
Kashyap> is not so severe considering real time exposure ?  Trying to
Kashyap> understand priority and severity of this issue.

Since you're presumably only handling reads and writes in the fast path,
I assume the sanity checking will be fairly simple and thus a candidate
for stable.

-- 
Martin K. Petersen	Oracle Linux Engineering
