From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v8 3/4] ata: Add APM X-Gene SoC SATA host controller
 driver
Date: Sun, 12 Jan 2014 06:49:58 -0500
Message-ID: <20140112114958.GA8509@mtj.dyndns.org>
References: <1389031922-4309-1-git-send-email-lho@apm.com>
 <1389031922-4309-2-git-send-email-lho@apm.com>
 <1389031922-4309-3-git-send-email-lho@apm.com>
 <1389031922-4309-4-git-send-email-lho@apm.com>
 <52D052F9.8050703@redhat.com>
 <20140111193104.GD3257@mtj.dyndns.org>
 <6EB44142-06DA-4C9D-8999-CFA9EE30E03D@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6EB44142-06DA-4C9D-8999-CFA9EE30E03D@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Loc Ho <lho@apm.com>
Cc: David Milburn <dmilburn@redhat.com>, "olof@lixom.net" <olof@lixom.net>, "arnd@arndb.de" <arnd@arndb.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "jcm@redhat.com" <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

On Sat, Jan 11, 2014 at 07:58:04PM -0800, Loc Ho wrote:
> The flush has to occurred immediately after reading the CI
> register. It can not wrap around the isr routine and issue the flush
> after or before the library ahci isr routine.

I see.  So, you're saying that if PMP support is disabled for the
controller, the driver would need to reimplement only the interrupt
handler?

thanks.

-- 
tejun
