From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [ufs]: [scsi]: BUG: spinlock recursion on CPU#4
Date: Thu, 1 Jun 2017 14:02:22 +0000
Message-ID: <1496325738.3075.1.camel@sandisk.com>
References: <bd79226b-833c-f53b-f92a-0c4ebffeb1ee@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:20880 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751078AbdFAOCZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jun 2017 10:02:25 -0400
In-Reply-To: <bd79226b-833c-f53b-f92a-0c4ebffeb1ee@codeaurora.org>
Content-Language: en-US
Content-ID: <5105D612FF61F241903DE87F3B73C19E@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>
Cc: "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>

On Thu, 2017-06-01 at 12:28 +0530, Asutosh Das (asd) wrote:
> Please can you check if this is actually a bug and my understanding is=20
> correct.

Hello Asutosh,

Spinlock recursion is always a bug. With what kernel version did you encoun=
ter
this? Was it with a kernel from kernel.org, a distro kernel or an Android k=
ernel?
Have you already tried to reproduce this with kernel debugging enabled? Ena=
bling
CONFIG_DEBUG_SPINLOCK and CONFIG_PROVE_LOCKING should provide more detailed
information.

Bart.=
