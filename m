From: Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH v13 3/3] arm64: Add APM X-Gene SoC AHCI SATA host controller
 DTS entries
Date: Tue, 25 Feb 2014 11:24:50 +0530
Message-ID: <530C302A.5070809@ti.com>
References: <1393221265-13057-1-git-send-email-lho@apm.com>	<1393221265-13057-2-git-send-email-lho@apm.com>	<1393221265-13057-3-git-send-email-lho@apm.com>	<1393221265-13057-4-git-send-email-lho@apm.com>	<20140224183218.GB2522@htj.dyndns.org> <CAPw-ZT=CNdGn_iPp+jJbymvgBTNpXe1nCLeNwPWBdD3AAnHE6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAPw-ZT=CNdGn_iPp+jJbymvgBTNpXe1nCLeNwPWBdD3AAnHE6A@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Loc Ho <lho@apm.com>, Tejun Heo <tj@kernel.org>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Don Dutile <ddutile@redhat.com>, Jon Masters <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

Hi,

On Tuesday 25 February 2014 06:44 AM, Loc Ho wrote:
> Hi Tejun,
> 
>     On Sun, Feb 23, 2014 at 10:54:25PM -0700, Loc Ho wrote:
>     > Signed-off-by: Loc Ho <lho@apm.com <mailto:lho@apm.com>>
>     > Signed-off-by: Tuan Phan <tphan@apm.com <mailto:tphan@apm.com>>
>     > Signed-off-by: Suman Tripathi <stripathi@apm.com <mailto:stripathi@apm.com>>
> 
>     This doesn't apply cleanly to libata/for-3.15.  How should this be
>     routed?
> 
> 
> You need to apply the corresponding PHY driver as well. Are you taken the
> corresponding PHY driver into your libata tree? If not, we will need to route
> to Kishon generic PHY framework tree. I include Kishon Vijay Abraham to this
> email thread.

I prefer dt entry go via dt maintainer. However I can add my Acked-by for the
dt patches if you can copy me in those patches.
> 
> Kishon,
> 
> Do I need to re-send my SATA PHY driver to you as I had being posting them to
> the scsi/arm mailing list? 

Yes please.

Thanks
Kishon
