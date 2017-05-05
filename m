From: Thierry Escande <thierry.escande@collabora.com>
Subject: Re: [PATCH v2] sd: Ignore sync cache failures when not supported
Date: Fri, 5 May 2017 13:46:26 +0200
Message-ID: <f9129c8a-de72-eb16-7e56-0003ddbacf27@collabora.com>
References: <1493891010-24258-1-git-send-email-thierry.escande@collabora.com>
 <20170505090201.GA31209@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170505090201.GA31209@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/05/2017 11:02, Christoph Hellwig wrote:
> Normally we'd just pass the scsi_sense_hdr structure in from the
> caler if we care about sense data.  Is this something you considered?
Not really as only the sense_key field is needed for only one call to 
sd_sync_cache() (out of two).

>
> Otherwise this looks fine to me.
>
