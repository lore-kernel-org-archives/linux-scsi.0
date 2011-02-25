From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH] x86: Moving probe_roms_32 to probe_roms
Date: Thu, 24 Feb 2011 17:27:07 -0800
Message-ID: <AANLkTikimHCsFmavDoXn3Pka8WWMePqk+hNUK8h=DqSQ@mail.gmail.com>
References: <20110222201538.15443.81915.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44418 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254Ab1BYBmI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2011 20:42:08 -0500
In-Reply-To: <20110222201538.15443.81915.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Jiang <dave.jiang@intel.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, David Milburn <dmilburn@redhat.com>

On Tue, Feb 22, 2011 at 12:16 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> From: Dave Jiang <dave.jiang@intel.com>
>
> Moving the probe_roms_32 code to probe_roms and make available for all x86. The
> end result adapter roms data structure is made available read-only to drivers.
> The Intel isci SAS driver needs to scan the OROM memory in order to pull OEM
> parameters from the OROM.
>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>
> We could just export adapter_rom_resources directly and be done with it, but
> it seemed reasonable to have a compile time catch for drivers that try to
> modify the resources, and that drivers should not assume the number of
> available adapter roms.
>

Ping?  The "RFC" was probably not needed, just wanted clarification if
the interface for modules to retrieve the adapter rom data was in good
taste.

Thanks,
Dan
