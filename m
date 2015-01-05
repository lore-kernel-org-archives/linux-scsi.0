From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] ahci_xgene: Implement the workaround to support PMP
 enumeration and discovery for APM X-Gene SoC AHCI SATA Host Controller
 driver.
Date: Mon, 5 Jan 2015 09:05:29 -0500
Message-ID: <20150105140529.GG15833@htj.dyndns.org>
References: <1420453305-15986-1-git-send-email-stripathi@apm.com>
 <1420453305-15986-3-git-send-email-stripathi@apm.com>
 <20150105133005.GB15833@htj.dyndns.org>
 <20150105135950.GE15833@htj.dyndns.org>
 <CAOHikRBedNy=CrrHA+7UYQJpL3t1BhU0VFixz80bPeSE28iHGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOHikRBedNy=CrrHA+7UYQJpL3t1BhU0VFixz80bPeSE28iHGw@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Mark Langsdorf <mlangsdo@redhat.com>, Jon Masters <jcm@redhat.com>, patches@apm.com
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 05, 2015 at 07:33:06PM +0530, Suman Tripathi wrote:
> Reverted due to conflicts with the endian fix patches.  Please rebase
> these two on top of them.
> 
> Will do that .. I should have wait for the endian patch getting
> accepted. Sorry for that.

Ooh, please don't be sorry.  It's completely fine.  These things
happen.

Thanks.

-- 
tejun
