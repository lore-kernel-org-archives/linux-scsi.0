From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] sd: fix sysfs writes to "provisioning_mode" and
 "zeroing_mode"
Date: Mon, 15 May 2017 21:14:10 +0000
Message-ID: <1494882849.2567.6.camel@sandisk.com>
References: <1494875606-6298-1-git-send-email-emilne@redhat.com>
         <1494879289.2567.3.camel@sandisk.com>
         <1494882178.1081.43.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:11518 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751364AbdEOVOM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 May 2017 17:14:12 -0400
In-Reply-To: <1494882178.1081.43.camel@localhost.localdomain>
Content-Language: en-US
Content-ID: <5D9D8D962F09CA4C99B82836C44A479A@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "emilne@redhat.com" <emilne@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, 2017-05-15 at 17:02 -0400, Ewan D. Milne wrote:
> I think it's the '\n' that actually causes the problem.

Agreed, and that's why I proposed to strip trailing whitespace.

> But, what I think we should do is use the same technique everywhere.

If you have a look at the block layer you will see that the block layer
sysfs code is already using strim() and strstrip().

> So, are you suggesting we change all the other sysfs store routines?

I will leave it to Martin and James to comment on this.

Bart.=
