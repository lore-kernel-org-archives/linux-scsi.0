From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: interpreting scsi errors (RAID)
Date: 09 Feb 2004 10:35:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1076340906.2090.3.camel@mulgrave>
References: <2198.137.195.14.4.1076324273.squirrel@www.macs.hw.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:4748 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261812AbUBIPfQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Feb 2004 10:35:16 -0500
In-Reply-To: <2198.137.195.14.4.1076324273.squirrel@www.macs.hw.ac.uk>
List-Id: linux-scsi@vger.kernel.org
To: Ross Macintyre <raz@macs.hw.ac.uk>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, ian@eclipsecomputing.co.uk, cos@vger.kernel.org

On Mon, 2004-02-09 at 05:57, Ross Macintyre wrote:
> I have seen this error twice now:
> 
> Adapter 1 Channel 1 Target 2: Sense Data: errCode=0x71  valBit=1 
> segMent=0x00  SenseKey=4  ILI=0  EOM=0  FMRK=0  Address=0x00005A8E 
> ASL=0xA  cmdSpec=0x0000  ASC=0x0C  ASCQ=0x00 FRUC Code + Sense Key
> Specific=0x8001

That's a non recoverable write error.

> I have an LSILogic Megaraid SCSI 320-1, running RAID level5, 4 disks, and
> the OS is RedHat8.0.
> 
> What I would like, is to be able to understand these messages.
> In particular I need to know if there is a hardware error which means that
> I can contact the retailer, in confidence, and ask for a replacement, as
> the disk is still under warranty.
> Any pointers at FAQs or READMEs greatly appreciated,

All the sense codes are documented in the current SCSI Primary Commands
document at the t10 webiste 

http://www.t10.org/ftp/t10/drafts/spc3/spc3r17.pdf

Although the pointer will change as the standard is revised.

James


