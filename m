From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH 02/12] hpsa: cleanup sas_phy structures in sysfs when
 unloading
Date: Mon, 23 Oct 2017 16:44:53 -0700
Message-ID: <1508802293.3209.3.camel@linux.vnet.ibm.com>
References: <150853443786.28275.17878578984391668998.stgit@brunhilda>
         <150853627417.28275.14954285884974003997.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58850 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751116AbdJWXpD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Oct 2017 19:45:03 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v9NNi40j047215
        for <linux-scsi@vger.kernel.org>; Mon, 23 Oct 2017 19:45:03 -0400
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2dskcm9p0m-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 23 Oct 2017 19:45:03 -0400
Received: from localhost
        by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Mon, 23 Oct 2017 17:45:02 -0600
In-Reply-To: <150853627417.28275.14954285884974003997.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

On Fri, 2017-10-20 at 16:51 -0500, Don Brace wrote:
> From: Martin Wilck <mwilck@suse.de>
> 
> I am resubmitting this patch on behalf of Martin Wilck
> with his permission.
> 
> The original patch can be found here:
> https://www.spinics.net/lists/linux-scsi/msg102083.html
> 
> This patch did not help until Hannes's
> commit 9441284fbc39 ("scsi-fixup-kernel-warning-during-rmmod")
> was applied to the kernel.
> 
> --------------------------------------
> Original patch description from Martin:
> --------------------------------------
> 
> When the hpsa module is unloaded using rmmod, dangling
> symlinks remain under /sys/class/sas_phy. Fix this by
> calling sas_phy_delete() rather than sas_phy_free (which,
> according to comments, should not be called for PHYs that
> have been set up successfully, anyway).
> 
> Tested-by: Don Brace <don.brace@microsemi.com>
> Reviewed-by: Don Brace <don.brace@microsemi.com>
> Signed-off-by: Martin Wilck <mwilck@xxxxxxx>

Hey, what's this for a signoff?  The original patch had the correct
email address; how did it get mangled like this?

James
