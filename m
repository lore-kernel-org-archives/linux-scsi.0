From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: 520 BPS data integrity vendors
Date: Fri, 02 Jul 2010 13:06:08 -0500
Message-ID: <1278093968.2856.169.camel@mulgrave.site>
References: <AANLkTilcpFgsYtEUkZ2zAU3SDs0jetiajYPzKUWgFMyD@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <AANLkTilcpFgsYtEUkZ2zAU3SDs0jetiajYPzKUWgFMyD@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Dan Porat <dan.porat@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2010-07-01 at 17:11 -0400, Dan Porat wrote:
> Hi ,
> 
> In the documentation of 2.6.34 it says "We have been working with
> several FC/SAS HBA vendors to enable the protection information to be
> transferred to and from their controllers"
> I would like to test SAS 520.

So I'm having a little difficulty parsing this: SAS 520 is actually a
financial audit standard (which I really wish I didn't know about) ... I
assume you're actually talking about DIF/DIX?  The integrity standard
for SCSI?

> Which Vendor and what specific SAS HBA model will support it ?
> Thanks

I've added linux-scsi, since this is a SCSI question not an IDE one. 

The only SAS HBA supporting DIF I know of with a working Linux driver is
the mpt2sas.  It supports DIF types 1 and 3.

James


