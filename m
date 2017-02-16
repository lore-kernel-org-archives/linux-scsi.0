From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: hch's native NVMe multipathing [was: Re: [PATCH 1/2] Don't
 blacklist nvme]
Date: Thu, 16 Feb 2017 17:37:41 +0000
Message-ID: <1487266648.2612.3.camel@sandisk.com>
References: <1487107154-24883-1-git-send-email-keith.busch@intel.com>
         <20170215145617.GA4241@infradead.org> <20170216025357.GA9241@redhat.com>
         <20170216142621.GA21972@infradead.org> <20170216151337.GA12678@redhat.com>
         <20170216173856.GB17828@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:56456 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754810AbdBPRlP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Feb 2017 12:41:15 -0500
In-Reply-To: <20170216173856.GB17828@localhost.localdomain>
Content-Language: en-US
Content-ID: <FFCCCA3B0F6A74478D915F666C8ACB4A@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "keith.busch@intel.com" <keith.busch@intel.com>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, 2017-02-16 at 12:38 -0500, Keith Busch wrote:
> Maybe I'm not seeing the bigger picture. Is there some part to multipath
> that the kernel is not in a better position to handle?

Does this mean that the code to parse /etc/multipath.conf will be moved into
the kernel? Or will we lose the ability to configure the policies that
/etc/multipath.conf allows to configure?

Bart.
