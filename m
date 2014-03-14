From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v17 2/4] Documentation: Add documentation for the APM X-Gene SoC SATA host controller DTS binding
Date: Fri, 14 Mar 2014 12:11:06 +0100
Message-ID: <201403141211.06320.arnd@arndb.de>
References: <1394655573-32645-1-git-send-email-lho@apm.com> <1394655573-32645-2-git-send-email-lho@apm.com> <1394655573-32645-3-git-send-email-lho@apm.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1394655573-32645-3-git-send-email-lho@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Loc Ho <lho@apm.com>
Cc: olof@lixom.net, tj@kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

On Wednesday 12 March 2014, Loc Ho wrote:
> +- clocks               : Reference to the clock entry.
> +- phys                 : A list of phandles + phy-specifiers, one for each
> +                         entry in phy-names.
> +- phy-names            : Should contain:
> +  * "sata-6g" for the SATA 6.0Gbps PHY
> +

The generic ahci binding has convered on using the string "sata-phy" for
ahci nodes. I think you should use the same for consistency. I realize
I agreed to using "sata-6g" earlier on, but the discussion about the
generic binding has moved on in the meantime and that is already merged.

	Arnd
