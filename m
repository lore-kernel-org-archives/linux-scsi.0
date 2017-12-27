From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 2/9] ufs: sysfs: interconnect descriptor
Date: Wed, 27 Dec 2017 16:20:17 +0100
Message-ID: <20171227152017.GC20967@kroah.com>
References: <1514387627-27817-1-git-send-email-stanislav.nijnikov@wdc.com>
 <1514387627-27817-3-git-send-email-stanislav.nijnikov@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49754 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751028AbdL0PUN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Dec 2017 10:20:13 -0500
Content-Disposition: inline
In-Reply-To: <1514387627-27817-3-git-send-email-stanislav.nijnikov@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, alex.lemberg@wdc.com

On Wed, Dec 27, 2017 at 05:13:40PM +0200, Stanislav Nijnikov wrote:
> This patch introduces a sysfs group entry for the UFS interconnect
> descriptor parameters. The group adds "interconnect_descriptor" folder
> under the UFS driver sysfs entry (/sys/bus/platform/drivers/ufshcd/*).
> The parameters are shown as hexadecimal numbers. The full information
> about the parameters could be found at UFS specifications 2.1.
> 
> Signed-off-by: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
