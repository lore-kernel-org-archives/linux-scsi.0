From: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: dead CONFIG_ variables:  drivers/scsi/
Date: Thu, 3 May 2007 12:11:13 +0100
Message-ID: <20070503111113.GC12018@flint.arm.linux.org.uk>
References: <Pine.LNX.4.64.0705030606570.32341@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3119 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbXECLLX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 May 2007 07:11:23 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705030606570.32341@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Thu, May 03, 2007 at 06:10:28AM -0400, Robert P. J. Day wrote:
> 
> $ ../dead_config.sh drivers/scsi
> ========== ACORNSCSI_CONSTANTS ==========
> drivers/scsi/arm/acornscsi.c:106:#undef CONFIG_ACORNSCSI_CONSTANTS
> drivers/scsi/arm/acornscsi.c:417:#ifdef CONFIG_ACORNSCSI_CONSTANTS
> drivers/scsi/arm/acornscsi.c:495:#ifdef CONFIG_ACORNSCSI_CONSTANTS
> ========== SCSI_ACORNSCSI_LINK ==========
> drivers/scsi/arm/acornscsi.c:70:#undef CONFIG_SCSI_ACORNSCSI_LINK
> drivers/scsi/arm/acornscsi.c:169:#ifdef CONFIG_SCSI_ACORNSCSI_LINK
> drivers/scsi/arm/acornscsi.c:1675:#ifdef CONFIG_SCSI_ACORNSCSI_LINK
> drivers/scsi/arm/acornscsi.c:2849:#ifdef CONFIG_SCSI_ACORNSCSI_LINK
> drivers/scsi/arm/acornscsi.c:2880:#ifdef CONFIG_SCSI_ACORNSCSI_LINK

False positives.  That #undef is preceded by a comment describing the
driver-internal configuration for developers rather than users.  I
guess they shouldn't be preceded by CONFIG_.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
