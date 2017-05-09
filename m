From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] sd: Ignore sync cache failures when not supported
Date: Mon, 08 May 2017 21:55:41 -0400
Message-ID: <yq1mvamssiq.fsf@oracle.com>
References: <1493891010-24258-1-git-send-email-thierry.escande@collabora.com>
        <20170505090201.GA31209@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170505090201.GA31209@infradead.org> (Christoph Hellwig's
        message of "Fri, 5 May 2017 02:02:01 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Thierry Escande <thierry.escande@collabora.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Christoph,

> Normally we'd just pass the scsi_sense_hdr structure in from the caler
> if we care about sense data.  Is this something you considered?
>
> Otherwise this looks fine to me.

I agree with Christoph that passing the sense header would be more
consistent with the rest of the SCSI code. Even if we only need the key
in this case.

-- 
Martin K. Petersen	Oracle Linux Engineering
