From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 35/82] remove linux/version.h from
	drivers/scsi/cpqfcTSinit.c
Date: Fri, 29 Jul 2005 21:43:54 -0500
Message-ID: <1122691434.5108.30.camel@mulgrave>
References: <20050710193543.35.MfBvHx3206.2247.olh@nectarine.suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S262728AbVG3CoR@vger.kernel.org>
In-Reply-To: <20050710193543.35.MfBvHx3206.2247.olh@nectarine.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Olaf Hering <olh@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2005-07-10 at 19:35 +0000, Olaf Hering wrote:
> changing CONFIG_LOCALVERSION rebuilds too much, for no appearent reason.
> remove code for obsolete kernels

I can't seem to get any of these patches to apply:

Applying 'remove linux/version.h from drivers/scsi/cpqfcTSinit.c'

patching file drivers/scsi/cpqfcTSinit.c
patch: **** malformed patch at line 4: #include <linux/config.h>

I've no idea what patch's problem is ... as far as I can tell there are
no line breaks or illegal characters in the email.

James
