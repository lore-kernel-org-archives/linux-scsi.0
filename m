From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: [PATCH v2 3/6] esp_scsi: Grant disconnect privilege for untagged
 commands
Date: Mon, 15 Oct 2018 09:33:19 +1300
Message-ID: <4719e984-2c7e-33e1-6e7c-16dea5d4f610@gmail.com>
References: <cover.1539497520.git.fthain@telegraphics.com.au>
 <91b9ff9fc19ba40e3a2562171c8cd78a2ce7dc79.1539497520.git.fthain@telegraphics.com.au>
 <20181014154753.GA19252@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181014154753.GA19252@infradead.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 15/10/18 04:47, Christoph Hellwig wrote:

>> +	*p++ = IDENTIFY(lp && (tp->flags & ESP_TGT_DISCONNECT), lun);
> I think lp should always be non-NULL here.

That indeed appears to be the case these days.

So we can't rely on !lp to detect when probing the bus any longer. What 
else would be available? Do commands used for device probing also have a 
tag these days by default?

Do we really need to make that distinction?

Cheers,

     Michael
