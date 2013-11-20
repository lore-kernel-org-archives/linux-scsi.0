From: Loc Ho <lho@apm.com>
Subject: Re: [PATCH v2 4/4] arm64: Add APM X-Gene SoC 6.0Gbps SATA PHY DTS entries
Date: Tue, 19 Nov 2013 16:08:42 -0800
Message-ID: <CAPw-ZTm8a2jj1ggu0wBgEgaZFphTpAsSROXE0_BjQFqH12crYw@mail.gmail.com>
References: <1384905197-3566-1-git-send-email-lho@apm.com>
	<1384905197-3566-2-git-send-email-lho@apm.com>
	<1384905197-3566-3-git-send-email-lho@apm.com>
	<1384905197-3566-4-git-send-email-lho@apm.com>
	<1384905197-3566-5-git-send-email-lho@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1384905197-3566-5-git-send-email-lho@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Olof Johansson <olof@lixom.net>, Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Jon Masters <jcm@redhat.com>, Loc Ho <lho@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

 Hi,

> +                       txbooster = <0x2 0x2 0x2 0x2 0x2 0x2>;
> +                       txskew = <0xa 0xa 0xa 0xa 0xa 0xa>;
[Loc Ho]
These isn't correct. They should be txboostgain and txeyetuning. I
will fix these in the next version.

-Loc
