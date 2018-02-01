From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v4 03/10] ufs: sysfs: interconnect descriptor
Date: Thu, 1 Feb 2018 18:01:39 +0100
Message-ID: <20180201170139.GC12838@kroah.com>
References: <1517501746-19075-1-git-send-email-stanislav.nijnikov@wdc.com>
 <1517501746-19075-4-git-send-email-stanislav.nijnikov@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47674 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752433AbeBARBp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Feb 2018 12:01:45 -0500
Content-Disposition: inline
In-Reply-To: <1517501746-19075-4-git-send-email-stanislav.nijnikov@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jaegeuk@kernel.org, alex.lemberg@wdc.com

On Thu, Feb 01, 2018 at 06:15:39PM +0200, Stanislav Nijnikov wrote:
> This patch introduces a sysfs group entry for the UFS interconnect
> descriptor parameters. The group adds "interconnect_descriptor" folder
> under the UFS driver sysfs entry (/sys/bus/platform/drivers/ufshcd/*).
> The parameters are shown as hexadecimal numbers. The full information
> about the parameters could be found at UFS specifications 2.1.
> 
> Signed-off-by: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
> 
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Nit, you should not have blank lines between these two statements,
otherwise tools can get confused.

You do that in later patches as well.

thanks,

greg k-h
