From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] SCSI Core cmd->host ==> cmd->device->host 2/3
Date: Sat, 11 Jan 2003 17:45:29 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030111174529.A2225@infradead.org>
References: <3E1A1C78.8050104@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E1A1C78.8050104@splentec.com>; from luben@splentec.com on Mon, Jan 06, 2003 at 07:16:56PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Jan 06, 2003 at 07:16:56PM -0500, Luben Tuikov wrote:
> This patch makes the conversion from scsi cmd->host to
> scsi cmd->device->host for drivers/scsi/*, drivers/usb/storage/*,
> drivers/ieee1394/*, drivers/message/fusion/* .

The patch looks fine in principle.  Two purely cosmetic nitpicks:

1) Please linewrap the now longer lines after 80 lines
2) the cast when assining from ->hostdata are superflous

I know 2) is not your fault, but as you touch it fixing that might make
sense, and usually fixes 1).

