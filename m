From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 24/24] osst: add a SPDX tag to osst.c
Date: Thu, 2 May 2019 16:19:05 +0200
Message-ID: <10a8c8f5-879c-685f-f43c-d5af678b2187@suse.de>
References: <20190501161417.32592-1-hch@lst.de>
 <20190501161417.32592-25-hch@lst.de>
 <70277444-5b5b-6e3c-5af3-c658a841b144@suse.de> <20190502125312.GA2560@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190502125312.GA2560@lst.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>, Willem Riede <osst@riede.org>, Doug Gilbert <dgilbert@interlog.com>, Jens Axboe <axboe@kernel.dk>, =?UTF-8?Q?Kai_M=c3=a4kisara?= <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, osst-users@lists.sourceforge.net, linux-kernel@vger.kernel.org, Chriosstoph Hellwig <hch@losst.de>
List-Id: linux-scsi@vger.kernel.org

On 5/2/19 2:53 PM, Christoph Hellwig wrote:
> On Thu, May 02, 2019 at 08:06:38AM +0200, Hannes Reinecke wrote:
>> On 5/1/19 6:14 PM, Christoph Hellwig wrote:
>>> osst.c is the only osst file missing licensing information.  Add a
>>> GPLv2 tag for the default kernel license.
>>>
>>> Signed-off-by: Chriosstoph Hellwig <hch@losst.de>
> 
> FYI, my s/st/osst/ on the commit message message up my signoff, this
> should be:
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
Maybe it's time to kill osst.c for good ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
