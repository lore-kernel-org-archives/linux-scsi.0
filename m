From: Michael Still <mikal@stillhq.com>
Subject: Re: Linux v2.5.47
Date: Wed, 13 Nov 2002 23:03:56 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.30.0211132302050.6360-100000@localhost.localdomain>
References: <20021113002222.B323@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021113002222.B323@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Wed, 13 Nov 2002, Christoph Hellwig wrote:

> You can convert it easily into a new-style pci driver with the following
> probe routine:

Remembering of course that a scsi_register() can fail...

> 	[do basic setup]
> 	sdev = scsi_register();

        if(sdev == NULL){
          /* Handle error */
          }

> 	[do more setup]
> 	return scsi_add_host();

Cheers,
Mikal

-- 

Michael Still (mikal@stillhq.com)     UTC +10 hours

