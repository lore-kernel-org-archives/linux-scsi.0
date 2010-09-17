From: Jeff Garzik <jeff@garzik.org>
Subject: Re: libata: SATL error processing: unrecovered read error
Date: Fri, 17 Sep 2010 14:31:52 -0400
Message-ID: <4C93B418.8040106@garzik.org>
References: <4C83BDDC.3020201@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4C83BDDC.3020201@interlog.com>
Sender: linux-ide-owner@vger.kernel.org
To: dgilbert@interlog.com
Cc: SCSI development list <linux-scsi@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 09/05/2010 11:57 AM, Douglas Gilbert wrote:
> While looking at an eSATA connected external disk with
> a medium error, this sense data appeared:
>
> READ cdb: 28 00 96 4a 7a d1 00 00 01 00
> duration=2816 ms
> READ: Descriptor format, current; Sense key: Medium Error
> Additional sense: Unrecovered read error - auto reallocate failed
> Descriptor type: Information
> 0x00000000964a7ad1
> Raw sense data (in hex):
> 72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
> 96 4a 7a d1
>
> That is pretty close to what I was expecting to see. If anything
> there is too much information. That "Unrecovered read error -
> auto reallocate failed" [asc/asq: 11h/04h] should just be
> "Unrecovered read error" [asc/asq: 11h/0h]. See sat2r09.pdf table
> 105 or sat3r00.pdf table 105.

If any auto-reallocate occurred on the drive's part, it definitely 
failed at that point.  And auto-reallocate is a possibility.

11h/04h seems to more accurately describe the situation.

	Jeff



