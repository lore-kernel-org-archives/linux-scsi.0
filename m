From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 2/3] target: Add TARGET_SCF_LOOKUP_LUN_FROM_TAG support
 for ABORT_TASK
Date: Fri, 9 Jun 2017 11:15:31 -0700
Message-ID: <d02e081d-fa64-5544-d9a4-964580a30208@sandisk.com>
References: <1496527808-28789-1-git-send-email-nab@linux-iscsi.org>
 <1496527808-28789-3-git-send-email-nab@linux-iscsi.org>
 <1496678246.2623.5.camel@sandisk.com>
 <1496987544.28997.34.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:34143 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751768AbdFISPs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jun 2017 14:15:48 -0400
In-Reply-To: <1496987544.28997.34.camel@haakon3.risingtidesystems.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mchristi@redhat.com" <mchristi@redhat.com>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "quinn.tran@cavium.com" <quinn.tran@cavium.com>, "hare@suse.com" <hare@suse.com>, "hch@lst.de" <hch@lst.de>

On 06/08/17 22:52, Nicholas A. Bellinger wrote:
> Because qla2xxx doesn't reuse tags, it's not a problem since it's the
> only consumer of TARGET_SCF_LOOKUP_LUN_FROM_TAG.

Hello Nic,

Can you clarify this? Since all target drivers and also the target core
use a finite number of bits to represent tags, tags *will* be reused
sooner or later.

Bart.
