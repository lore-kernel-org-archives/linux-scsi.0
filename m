From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 1/3] Documentation: Add APM X-Gene SoC 6.0Gbps SATA PHY driver binding documentation
Date: Fri, 15 Nov 2013 13:35:09 +0100
Message-ID: <201311151335.09577.arnd@arndb.de>
References: <1384457519-21335-1-git-send-email-lho@apm.com> <1384457519-21335-2-git-send-email-lho@apm.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1384457519-21335-2-git-send-email-lho-qTEPVZfXA3Y@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>
Cc: olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Tuan Phan <tphan-qTEPVZfXA3Y@public.gmane.org>, Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thursday 14 November 2013, Loc Ho wrote:
> +- id                   : PHY ID (0 = first, 1 = second, 2 = third)
> +- #phy-cells           : Shall be 0

Hmm, it seems like this would make more sense if you have #phy-cells=<1>
and have the PHY ID in user node as the argument.

> +- CTLE0                        : PHY override parameters for channel 0 register REG1
> +                         field CTLE_EQ. First value for Gen1, second value
> +                         for Gen2, and third value for Gen3. Default is 0x2.
> +- CTLE1                        : PHY override parameters for channel 1 register REG1
> +                         field CTLE_EQ. First value for Gen1, second value
> +                         for Gen2, and third value for Gen3. Default is 0x2.
> +- PQ0                  : PHY override parameters for channel 0 register REG125
> +                         field PQ_REG. First value for Gen1, second value
> +                         for Gen2, and third value for Gen3. Default is 0xA.
> +- PQ1                  : PHY override parameters for channel 1 register REG125
> +                         field PQ_REG. First value for Gen1, second value
> +                         for Gen2, and third value for Gen3. Default is 0xA.

As mentioned before, I don't think putting register-level information into the binding
is the right approach here.

	Arnd
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
