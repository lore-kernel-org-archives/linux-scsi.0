From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH] SCSI Core cmd->host ==> cmd->device->host 2/3
Date: Mon, 13 Jan 2003 11:46:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E22ED80.60408@splentec.com>
References: <3E1A1C78.8050104@splentec.com> <20030111174529.A2225@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Mon, Jan 06, 2003 at 07:16:56PM -0500, Luben Tuikov wrote:
> 
>>This patch makes the conversion from scsi cmd->host to
>>scsi cmd->device->host for drivers/scsi/*, drivers/usb/storage/*,
>>drivers/ieee1394/*, drivers/message/fusion/* .
> 
> 
> The patch looks fine in principle.  Two purely cosmetic nitpicks:
> 
> 1) Please linewrap the now longer lines after 80 lines
> 2) the cast when assining from ->hostdata are superflous
> 
> I know 2) is not your fault, but as you touch it fixing that might make
> sense, and usually fixes 1).

I wanted to minimize distuption as much as possible, for this reason
I didn't do as much of 1) or 2). I was tempted, but the principle
prevailed.

Such changes will have to be done at the next overhaul.

-- 
Luben



