From: Laurence Oberman <oberman.l@gmail.com>
Subject: Re: Sniffing FC traffic
Date: Fri, 18 Aug 2017 09:31:28 -0400
Message-ID: <CAAzz28iHSJjdTR9J67Wuxfd2b5WV4eDKR6GnM+S+i6CXBTVLrg@mail.gmail.com>
References: <20170818123717.GB4074@glanzmann.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:36326 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752617AbdHRNb3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Aug 2017 09:31:29 -0400
In-Reply-To: <20170818123717.GB4074@glanzmann.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>

On Fri, Aug 18, 2017 at 8:37 AM, Thomas Glanzmann <thomas@glanzmann.de> wrote:
> Hello,
> I would like to create a setup that allows me to sniff FC traffic. Is it
> possible with Linux or can someone recommend a setup that works. I want
> to avoid buying a 120kUSD fabric analyzer.
>
> Cheers,
>         Thomas

There is no way to do this using adapters and generic F/C with Linux as the O/S.
The ability to enable debugging in the F/C drivers will expose some of
the internals but there is no way to sniff directly as far as I am
aware.

Many switches allow port level tracing facilities but inline sniffing
using Linux and generic hosts is not possible.

We have Finisars for inline tracing when we have to debug host and
fabric issues.

Software based FCOE using libfc and the Intel cards for example will
allow Wireshark tracing but that is encapsulated F/C in Ethernet
packets hence the Wireshark ability.

Thanks
Laurence
