From: "Jun'ichi Nomura" <jnomura@mtc.biglobe.ne.jp>
Subject: megaraid driver always fails to reset adapter
Date: Tue, 01 Mar 2005 13:36:04 -0500
Message-ID: <4224B614.9060403@mtc.biglobe.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Received: from mx1.redhat.com ([66.187.233.31]:8858 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S261980AbVCASgN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2005 13:36:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I found that the megaraid driver always fails to reset the
adapter with the following message:
    megaraid: resetting the host...
    megaraid mbox: reset sequence completed successfully
    megaraid: fast sync command timed out
    megaraid: reservation reset failed
when the "Cluster mode" of the adapter BIOS is enabled.
So, whenever the reset occurs, the adapter goes to
offline and just become unavailable.

Is this a known problem?

I tried 2.6.9 and 2.6.11-rc5 and the results were the same.
I used sg_reset to invoke reset artificially to test this.

The problem doesn't occur if I disabled the "Cluster mode"
parameter in the adapter BIOS.

I'm not sure how well the currenet megaraid driver supports
the "Cluster mode".
I appreciate if you have any idea.

Thanks,
Jun'ichi Nomura

