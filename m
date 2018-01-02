From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v4 net-next 0/4] qed*: Advance to FW 8.33.1.0
Date: Tue, 02 Jan 2018 13:58:36 -0500 (EST)
Message-ID: <20180102.135836.317444223426222615.davem@davemloft.net>
References: <1514395808-16916-1-git-send-email-Tomer.Tayar@cavium.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:51038 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751390AbeABS6i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jan 2018 13:58:38 -0500
In-Reply-To: <1514395808-16916-1-git-send-email-Tomer.Tayar@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomer.Tayar@cavium.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org

From: Tomer Tayar <Tomer.Tayar@cavium.com>
Date: Wed, 27 Dec 2017 19:30:04 +0200

> This series advances all qed* drivers to use firmware 8.33.1.0 which brings
> new capabilities and initial support of new HW. The changes are mostly in
> qed, and include changes in the FW interface files, as well as updating the
> FW initialization and debug collection code. The protocol drivers have
> minor functional changes for this firmware.
> 
> Patch 1 Rearranges and refactors the FW interface files in preparation of
> the new FW (no functional change).
> Patch 2 Prepares the code for support of new HW (no functional change).
> Patch 3 Actual utilization of the new FW.
> Patch 4 Advances drivers' version.
> 
> v3->v4:
> Fix a compilation issue which was reported by krobot (dependency on CRC8).
> 
> v2->v3:
> Resend the series with a fixed title in the cover letter.
> 
> v1->v2:
> - Break the previous single patch into several patches.
> - Fix compilation issues which were reported by krobot.

I'm going to apply this, however....

These firmware update changes are rediculously invasive.

Backporting patches through these updates will be a giant task if not
impossible for anyone who tries to do something like this.

Who reviewed these changes outside of Cavium to look for clerical
and typographical errors?  I be nobody did.  I personally scanned
them for about 20 minutes.

Therefore, it is my judgment that the way firmware support updates are
done in the QED driver is detrimental to it's long term
maintainability.

Thank you.
