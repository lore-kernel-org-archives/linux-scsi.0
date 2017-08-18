From: Thomas Glanzmann <thomas@glanzmann.de>
Subject: Re: HBA recommended as FC target
Date: Fri, 18 Aug 2017 17:45:33 +0200
Message-ID: <20170818154533.GB21837@glanzmann.de>
References: <CAAzz28iHSJjdTR9J67Wuxfd2b5WV4eDKR6GnM+S+i6CXBTVLrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from infra.glanzmann.de ([88.198.249.254]:33422 "EHLO
        infra.glanzmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752297AbdHRPpi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Aug 2017 11:45:38 -0400
Content-Disposition: inline
In-Reply-To: <CAAzz28iHSJjdTR9J67Wuxfd2b5WV4eDKR6GnM+S+i6CXBTVLrg@mail.gmail.com>
 <CAAzz28hH10wsJhLnQP5WeNLxnn_qbS4MWCHE1jtPLdYhfoCaEw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <oberman.l@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>

Hello Laurence,

* Laurence Oberman <oberman.l@gmail.com> [2017-08-18 15:26]:
> Any of the Qlogic qla24xx or qla25xx and higher that allow you to
> disable initiator mode will work.  I use qla25xx 8Gbit in all my
> Target arrays.

thank you for your recommendations I ordered a Qlogic QLE2462-HP
-PX2510401 - 4GB 2-Port Fibre on ebay.

* Laurence Oberman <oberman.l@gmail.com> [2017-08-18 15:31]:
> There is no way to do this using adapters and generic F/C with Linux
> as the O/S. The ability to enable debugging in the F/C drivers will
> expose some of the internals but there is no way to sniff directly as
> far as I am aware.

I enabled debugging in the Linux target once and I could see quiet
detailed information. Probably this will be enough for me. At the time I
was debugging SCSI reservations.

> Many switches allow port level tracing facilities but inline sniffing
> using Linux and generic hosts is not possible.

Are you aware of facilities in entry level brocade switches that I can
use. I just have to trace one port.

Cheers,
        Thomas
