From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: aic79xx and RAID ?
Date: Thu, 01 Dec 2005 11:37:30 +0100
Message-ID: <1133433450.2853.25.camel@laptopd505.fenrus.org>
References: <20051201102039.GA23336@danisch.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:51684 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932131AbVLAKhd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Dec 2005 05:37:33 -0500
In-Reply-To: <20051201102039.GA23336@danisch.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hadmut Danisch <hadmut@danisch.de>
Cc: linux-scsi@vger.kernel.org

On Thu, 2005-12-01 at 11:20 +0100, Hadmut Danisch wrote:
> Hi,
> 
> I have a question about the aic79xx driver and RAID.
> 
> A friend of mine tries to install Linux on a IBM rack server machine,
> which has two hard disks and a aic 7902 SCSI/RAID controller. 

ah one of the software raid controllers

> However, when booting Linux (SuSE or Knoppix), the kernel recognizes
> the controller and loads the aic79xx driver, but does not recognize
> the RAID mirror. Instead it presents both disks as separate disks
> /dev/sda and /dev/sdb. 

this is in principle the right thing for this kind of software raid.
the dmraid tool is there to support this type of software raid (bios
supported raid) but I don't think it supports adaptec raid yet...


