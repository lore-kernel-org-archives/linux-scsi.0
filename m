From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: SCSI selection issue with aic7xxx_old driver
Date: Fri, 31 Mar 2006 12:59:15 +0200
Message-ID: <1143802756.3053.0.camel@laptopd505.fenrus.org>
References: <F6783F90-89ED-4D3C-9D42-8F97D91907E0@sbcglobal.net>
Reply-To: arjan@infradead.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from morbo.e-centre.net ([66.154.82.3]:26353 "EHLO
	cubert.e-centre.net") by vger.kernel.org with ESMTP
	id S1751313AbWCaK7S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Mar 2006 05:59:18 -0500
In-Reply-To: <F6783F90-89ED-4D3C-9D42-8F97D91907E0@sbcglobal.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kevin K <k_krieser@sbcglobal.net>
Cc: linux-scsi@vger.kernel.org

On Wed, 2006-03-29 at 11:51 -0600, Kevin K wrote:
> I'm in the process up converting from RHEL 2.1 to RHEL 4, and have  
> encountered an issue with the aic7xxx_old driver (5.2.6, as provided  
> with the RH 2.4.9-34 kernel, and with 2.6.15.5 kernel).
> 
>   The SCSI card is an Adaptec 2940U card.
> 
>   Namely, an old SCSI device isn't being seen very often.  Maybe 1 in  
> 10 times loading the module.  Under the 2.4.18 kernel, it was always  
> seen using this driver except in the case of hardware/cabling issues.
> 
>   With the same hardware and OS, but using the new driver (aic7xxx),  
> the hardware is consistently seen.

well... sounds you have a solution right there... ;)
the _old driver isn't really actively maintained anymore since... a long
time. At least the "new" one has been getting maintenance

