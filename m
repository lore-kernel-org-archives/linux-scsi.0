From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: IO Data USB HD - read/write with SGIO ioctl does not acces the
	drive, kernel 2.6.15.6
Date: Mon, 15 May 2006 16:49:16 -0500
Message-ID: <1147729756.3529.109.camel@mulgrave.il.steeleye.com>
References: <4468E16F.4060709@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:48521 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S965262AbWEOVtT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 May 2006 17:49:19 -0400
In-Reply-To: <4468E16F.4060709@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dario Oliva <anikami1@gmail.com>
Cc: linux-scsi@vger.kernel.org, doliva@arcoide.com

On Mon, 2006-05-15 at 16:15 -0400, Dario Oliva wrote:
> I am trying to use the SG_IO ioctl from the scsi driver to read and 
> write raw
> data to this USB hard drive (IO Data USB HD). I have googled the device 
> name and
> only came up with 13 sites, none of which had any information for this 
> problem.
> This is a link to a reseller in California who sells the device I am using
> http://www.devicenet-usa.com/product_en.html#hdp
> 
> To verify that the data was not being written from the device or read 
> from the device,
> I used a protocol analyzer connected to the hard disk While sending the 
> read or write
> commands using SG_IO, there was no activity on the disk. I have also 
> used a program I wrote
> that reads individual sectors from a disk and displays the data in a 
> format similar to hexdump.
> The output from that program is also attached, in the file named data. 
> As you will see, I did a read
> several times from sector 0, receiving different slightly different 
> values every time.

SG_IO seems to be working fine for me on SCSI devices.  Could you use
sg_dd (on the /dev/sd<x> node) to determine if this may be some problem
with your applications usage of SG_IO (i.e. compare the results of an
ordinary dd and a sg_dd of the same part of the disc).

Thanks,

James


