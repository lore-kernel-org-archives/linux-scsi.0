From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 1/3 ] SCSI: Support several features in arcmsr driver
Date: Thu, 08 Apr 2010 17:53:58 -0400
Message-ID: <1270763638.2837.148.camel@mulgrave.site>
References: <1C89D804FCDA41259DEBE60429B71A63@areca4e4f859d4>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36666 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758546Ab0DHVyH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Apr 2010 17:54:07 -0400
In-Reply-To: <1C89D804FCDA41259DEBE60429B71A63@areca4e4f859d4>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nick.cheng@areca.com.tw
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, 2010-04-02 at 12:01 +0800, Nick Cheng wrote:
> 1. To support instantaneous report for SCSU device change by periodic
> polling
> 2. In arcmsr_iop_xfer(), inform AP of F/W's deadlock state to prevent
> endless waiting
> 3. To block the coming SCSI command while the driver is handling bus reset
> 4. To support HW reset in bus reset error handler

Next time, one patch per feature, please ...

I still need you to redo this one (and the SCSI reset one) in a non word
wrapped format so they can be applied ... just do an attachment since
getting outlook to attach patches inline seems to be close to
impossible.

James


