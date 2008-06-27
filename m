From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] libata support for rotation speed
Date: Fri, 27 Jun 2008 02:56:41 -0400
Message-ID: <48648F29.8040806@garzik.org>
References: <20080619160216.GH4392@parisc-linux.org> <20080619175904.GK4392@parisc-linux.org> <1213899895.3501.45.camel@localhost.localdomain> <20080619183113.GM4392@parisc-linux.org> <485AAD0D.9000205@garzik.org> <20080619191337.GO4392@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080619191337.GO4392@parisc-linux.org>
Sender: linux-ide-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Thu, Jun 19, 2008 at 03:01:33PM -0400, Jeff Garzik wrote:
>> Matthew Wilcox wrote:
>>> On Thu, Jun 19, 2008 at 01:24:55PM -0500, James Bottomley wrote:
>>>> This looks like it can be called for ATA_DEV_ATAPI as well, in which
>>>> case it's an illegal page to ask for.
>>> I was under the impression that this entire file is only used for
>>> non-atapi devices.
>> Correct.  That code path is not travelled by ATAPI.
> 
> Thanks, Jeff.  Here's version three, including the form factor from word
> 168:
> 
> 
> Add support for VPD page b1 to libata
> 
> SCSI VPD page b1 reports the nominal rotation speed and physical size
> of the device.  Devices that conform to ATA-8 can return this information
> in words 217 and 168 of the identify data.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

applied (2.6.27)


