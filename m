From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 2/4] Documentation: Add documentation for APM X-Gene SATA controllor DTS binding
Date: Fri, 15 Nov 2013 14:28:24 +0100
Message-ID: <201311151428.25204.arnd@arndb.de>
References: <1384465153-29902-1-git-send-email-lho@apm.com> <1384465153-29902-2-git-send-email-lho@apm.com> <1384465153-29902-3-git-send-email-lho@apm.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:65527 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab3KON2g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Nov 2013 08:28:36 -0500
In-Reply-To: <1384465153-29902-3-git-send-email-lho@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Loc Ho <lho@apm.com>
Cc: olof@lixom.net, tj@kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, jcm@redhat.com, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

On Thursday 14 November 2013, Loc Ho wrote:
> +Required properties:
> +- compatible           : Shall be "apm,xgene-ahci"
> +- reg                  : First memory resource shall be the AHCI memory
> +                         resource.
> +                         Second memory resource shall be the host controller
> +                         memory resource.
> +- id                   : Controller ID (0 = first, 1 = second, 2 = third)

As in the PHY patch, it's probably best to drop the "id" property here and
describe the actual differences between the instances directly, either by
having distinct "compatible" properties for each model, or by adding binary
flags to tell about a capability that only some instances have.

Also, I think you should have a separate file for the sata binding, especially
since the PHY binding is not actually specific to SATA at all.

Aside from these, the binding looks good to me now.

	Arnd
