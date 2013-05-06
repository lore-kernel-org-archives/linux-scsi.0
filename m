From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: [PATCH 1/1] Create megaraid ioctl device node
Date: Mon, 06 May 2013 16:23:44 +0200
Message-ID: <87a9o86vbj.fsf@nemi.mork.no>
References: <AB5E58B87EB73C46A38073D8F459F113D9FBA4@dataspheresrv01>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AB5E58B87EB73C46A38073D8F459F113D9FBA4@dataspheresrv01> (Patrick
	Monnerat's message of "Mon, 6 May 2013 15:58:31 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Monnerat <Patrick.Monnerat@datasphere.ch>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

"Patrick Monnerat" <Patrick.Monnerat@datasphere.ch> writes:

> From: Patrick Monnerat <pm@datasphere.ch>
>
>   Create ioctl device node for megaraid_sas driver. Let this node be
> managed by udev. Fix a typo.

Or maybe just simplify it all and use a misc device instead?  See how
this is done in e.g. drivers/scsi/mpt3sas/mpt3sas_ctl.c or
drivers/message/fusion/mptctl.c



Bj=C3=B8rn
