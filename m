From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: tmscsim (AM53C974) SCSI driver & 2.5
Date: Sat, 11 May 2002 19:29:18 +0100 (BST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E176bcM-0008Rj-00@the-village.bc.nu>
References: <20020510220518.K11690@gum01m.etpnet.phys.tue.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020510220518.K11690@gum01m.etpnet.phys.tue.nl> from "Kurt Garloff" at May 10, 2002 10:05:18 PM
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>

> Fixing (1) is easy for me as I have done the same conversion for the DC3x5
> driver. New EH takes somewhat more time, I'm afraid.
> I just wonder why nobody complained to me, so far:
> Is anybody using this driver?

Statistically speaking nobody is using 2.5. I2O is completely broken in 2.5
definitely has users and nobody has noticed yet who cares. Its not uncommon
for really obscure drivers not to get tested until 2.x-pre or later sometimes
