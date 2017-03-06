From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [ANNOUNCE]: Broadcom (Emulex) FC Target driver - efct
Date: Mon, 6 Mar 2017 17:53:04 +0000
Message-ID: <1488822771.3125.1.camel@sandisk.com>
References: <ced2ff0a-05ee-b85e-b41a-f912cab9e267@gmail.com>
         <1488485325.5580.9.camel@haakon3.risingtidesystems.com>
         <20170305173528.00006b41@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20170305173528.00006b41@gmx.de>
Content-Language: en-US
Content-ID: <F62559FF467B4D43A37F9E407704C77C@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: "jsmart2021@gmail.com" <jsmart2021@gmail.com>, "herbszt@gmx.de" <herbszt@gmx.de>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2017-03-05 at 17:35 +0100, Sebastian Herbszt wrote:
> Just like Hannes I do favour integration. I guess it could be
> comparable to qla2xxx + tcm_qla2xxx, lpfc + lpfc_scst and
> lpfc + tcm_lpfc. That approach might even help Bart with his
> target driver unification if he didn't give up on that topic.

Hello Sebastian,

That project is still on my to-do list :-) However, while I was
working on that project I hit bugs related to abort handling in
the QLogic FC and also in the iSCSI target drivers. I want to fix
these bugs first because otherwise if my tests fail it is not
possible to figure out whether I hit a regression or an existing
bug.

Bart.=
