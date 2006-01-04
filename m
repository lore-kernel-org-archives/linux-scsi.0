From: Mark Rustad <mrustad@mac.com>
Subject: Re: aic94xx linux driver
Date: Wed, 4 Jan 2006 17:37:58 -0600
Message-ID: <C8B2ECEF-34CF-4764-A82C-C3144512F449@mac.com>
References: <001501c6114f$7a6c3c00$520c220a@vugd.gov.lv>
Mime-Version: 1.0 (Apple Message framework v746.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpout.mac.com ([17.250.248.46]:60394 "EHLO smtpout.mac.com")
	by vger.kernel.org with ESMTP id S1750720AbWADXiP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jan 2006 18:38:15 -0500
In-Reply-To: <001501c6114f$7a6c3c00$520c220a@vugd.gov.lv>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Deniss <denis@msh.lv>
Cc: linux-scsi@vger.kernel.org

Deniss,

On Jan 4, 2006, at 10:54 AM, Deniss wrote:

> Hello !
>
> I have Supermicro 6014H-32 server with adaptec 9410w SAS/SATA  
> controller on board.
> I have linux kernel compiled with aic94xx driver from http:// 
> linux.adaptec.com/sas/
> I am notice that SAS disks work well with this driver, but SATA  
> disks are not mapped to /dev by driver.
> I tried to contact Luben Tuikov without success.
> Looks like aic94xx driver is not complete or have no SATA support

I have the same issue. By looking in /sys, you can see that the  
driver does see SATA disks, but there is no software connection  
between libata in the kernel and the SATA-tunneling protocol  
capability of the Adaptec SAS driver yet. I'm sure that there will be  
an increasing chorus of folks looking for this missing piece.

-- 
Mark Rustad, MRustad@mac.com

