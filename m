From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sd: block: Handle cases where devices come online read-only
Date: Tue, 12 Feb 2019 11:50:06 -0500
Message-ID: <yq18syluf29.fsf@oracle.com>
References: <20190208233831.31377-1-martin.petersen@oracle.com>
        <20190212080319.GA10547@infradead.org>
        <6121a378-d92f-3acb-8932-433c777205c3@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <6121a378-d92f-3acb-8932-433c777205c3@suse.de> (Hannes Reinecke's
        message of "Tue, 12 Feb 2019 09:08:40 +0100")
Sender: stable-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Jeremy Cline <jeremy@jcline.org>, Oleksii Kurochko <olkuroch@cisco.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Hannes,

> And once we stop sending I/O to it we'll lose the ability to figure
> out that the device switched back to R/W mode.
>
> (Always assuming that we'll be getting a sense code in the first
> place).

FWIW, I did get correct sense on all the drives I tested and verified
that the code does the right thing.

But obviously I have my doubts about $RANDOM_USB_GIZMO.

-- 
Martin K. Petersen	Oracle Linux Engineering
