From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi_debug: Add OPTIMAL TRANSFER LENGTH GRANULARITY option.
Date: Fri, 20 Jan 2017 19:24:24 -0500
Message-ID: <yq1pojhgszr.fsf@oracle.com>
References: <lherbolt@redhat.com>
        <1483779027-10052-1-git-send-email-lherbolt@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41031 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752287AbdAUAYy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jan 2017 19:24:54 -0500
In-Reply-To: <1483779027-10052-1-git-send-email-lherbolt@redhat.com> (Lukas
        Herbolt's message of "Sat, 7 Jan 2017 09:50:26 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lukas Herbolt <lherbolt@redhat.com>
Cc: dgilbert@interlog.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org

>>>>> "Lukas" == Lukas Herbolt <lherbolt@redhat.com> writes:

Lukas,

Lukas> I have been playing with scsi_debug and found that there is no
Lukas> way how to change the minimum_io_size (OPTIMAL TRANSFER LENGTH
Lukas> GRANULARITY reported by VPD 0xb0).

Lukas> The current module has minimum_io_size always set to
Lukas> physical_block_size.  So here comes a small patch which add a new
Lukas> option to this module to be able to set it independently to the
Lukas> physical_block_size. Default behavior is to keep the
Lukas> minimum_io_size equal to the physical_block_size.

No objection to the functionality but I don't really like the naming
scheme. There are many granularities in SBC so "gran" isn't particularly
descriptive.

How about opt_xferlen_exp or something like that?

-- 
Martin K. Petersen	Oracle Linux Engineering
