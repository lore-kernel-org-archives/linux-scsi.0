From: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [RFC PATCH 2/6] ACPI: Reference devices in ACPI Power Resource
Date: Mon, 20 Feb 2012 13:43:51 +0800
Message-ID: <1329716631.1511.23.camel@rui.sh.intel.com>
References: <1329124271-29464-1-git-send-email-ming.m.lin@intel.com>
	 <201202142336.28706.rjw@sisk.pl>
	 <1329376686.28581.15.camel@rui.sh.intel.com>
	 <201202172334.04301.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201202172334.04301.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Lin Ming <ming.m.lin@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On =E4=BA=94, 2012-02-17 at 23:34 +0100, Rafael J. Wysocki wrote:
>=20
> > So I introduced these two APIs so that an runtime_resume request ca=
n be
> > sent to ZPODD directly and the runtime PM core can resume all the
> > parents of ZPODD automatically.
>=20
> It seems that you're confusing things.  In the Linux driver model a d=
evice
> cannot have more than a single parent.
>
sorry, I mean the ancients here, e.g. scsi-host, etc. :)

thanks,
rui
