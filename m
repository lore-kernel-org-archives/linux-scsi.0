From: Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH] zfcp: convert zfcp to use target reset and device reset handler
Date: Mon, 3 Mar 2008 10:40:10 +0000
Message-ID: <20080303104010.GA18398@flint.arm.linux.org.uk>
References: <1204331123-3833-1-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-2-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-3-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-4-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-5-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-6-git-send-email-michaelc@cs.wisc.edu> <20080301133632.GB5098@schmichrtp.de.ibm.com> <20080303093924.GA8698@osiris.boeblingen.de.ibm.com> <20080303101231.GA20838@schmichrtp.de.ibm.com> <20080303101946.GB20838@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39300 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972AbYCCKlE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Mar 2008 05:41:04 -0500
Content-Disposition: inline
In-Reply-To: <20080303101946.GB20838@schmichrtp.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, james.smart@emulex.com, andrew.vasquez@qlogic.com, mp3@de.ibm.com, matthew@wil.cx

On Mon, Mar 03, 2008 at 11:19:46AM +0100, Christof Schmitt wrote:
> +static int zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *scpnt)
> +{
> +	int retval;
> +	struct zfcp_unit *unit = (struct zfcp_unit *) scpnt->device->hostdata;

Randomly spotted item.  Isn't hostdata of type void *?

        void *hostdata;         /* available to low-level driver */

in which case, isn't that cast, which is being added, redundant?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
