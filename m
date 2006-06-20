From: Brian King <brking@us.ibm.com>
Subject: Re: Status of SAS ability to attach SATA devices
Date: Tue, 20 Jun 2006 07:55:45 -0500
Message-ID: <4497F051.2050601@us.ibm.com>
References: <6ac07bf90606191047o131ec37eq6e1bcaf6205ea8ea@mail.gmail.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <6ac07bf90606191047o131ec37eq6e1bcaf6205ea8ea@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Ilia Sotnikov <hostcc@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jgarzik@pobox.com, James.Bottomley@steeleye.com
List-Id: linux-scsi@vger.kernel.org

Ilia Sotnikov wrote:
> Hardware: IBM 206m, AIC 9405 SAS/SATA controller, 2 SATA drives.
> 
> Having read several threads about SAS ability to attach SATA devices
> (what's needed in my case), I found that this is work-in-progress.

I have a patchset to libata to enable the ipr driver to attach
SATA devices. My hope was that other drivers would be able to use this
as well.

> I've tried all three of above mentioned versions - PHYs are discovered
> correctly (as far as I can tell) but no disk devices are registered.
> According to comments in sources that's predictable.
> 
> Questions are:
> - what tree is recommended to work on;

I'm not sure if there is a single tree right now. scsi-misc-2.6 has all
the latest SAS transport updates and libata-dev#upstream has all the latest
libata changes. 


Brian

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
