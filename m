From: Matthew Wilcox <willy@debian.org>
Subject: Re: Which U320 SCSI controler can be used on IA64 Systems
Date: Thu, 28 Aug 2003 12:12:46 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030828111246.GS22294@parcelfarce.linux.theplanet.co.uk>
References: <200308271505.53086.manz@intes.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:33773 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S263925AbTH1LMw
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2003 07:12:52 -0400
Content-Disposition: inline
In-Reply-To: <200308271505.53086.manz@intes.de>
List-Id: linux-scsi@vger.kernel.org
To: Hartmut Manz <manz@intes.de>
Cc: linux-scsi@vger.kernel.org

On Thu, Aug 28, 2003 at 09:08:44AM +0200, Hartmut Manz wrote:
> Hello,
> 
> I need to extend an ITANIUM-2 system with a 4 way striped scratch file-system.
> Now I am looking for working U320 SCSI controllers.
> 
> Could anyone tell me which SCSI controller is working on IA64.

hp ships ia64 boxes based on the LSI 1030 controller.

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
