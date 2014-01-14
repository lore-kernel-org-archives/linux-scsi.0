From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v8 3/4] ata: Add APM X-Gene SoC SATA host controller
 driver
Date: Tue, 14 Jan 2014 11:30:08 -0500
Message-ID: <20140114163008.GJ12131@htj.dyndns.org>
References: <52D052F9.8050703@redhat.com>
 <20140111193104.GD3257@mtj.dyndns.org>
 <6EB44142-06DA-4C9D-8999-CFA9EE30E03D@apm.com>
 <20140112114958.GA8509@mtj.dyndns.org>
 <CAPw-ZTmfKfPY3DRfJT6FQP78ULwfcjGG76cNfr9yk7UMdrO4wg@mail.gmail.com>
 <20140113160843.GB29053@htj.dyndns.org>
 <CAPw-ZT=A=c9-3BfP-LoDBXByQqfvATpAdS4NPPWB9+R1+GHfDA@mail.gmail.com>
 <20140114160312.GH12131@htj.dyndns.org>
 <20140114160419.GI12131@htj.dyndns.org>
 <CAPw-ZTmn6JiDku=vz=m9v5MNuFrK_-d0ehU_88drCYGHM8Wv=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPw-ZTmn6JiDku=vz=m9v5MNuFrK_-d0ehU_88drCYGHM8Wv=Q@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Loc Ho <lho@apm.com>
Cc: David Milburn <dmilburn@redhat.com>, "olof@lixom.net" <olof@lixom.net>, "arnd@arndb.de" <arnd@arndb.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "jcm@redhat.com" <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 14, 2014 at 08:21:28AM -0800, Loc Ho wrote:
> In the ISR, the AHCI library code reads the CI register and then
> performs XOR to determine which commands are completed. Then it goes
> and processes the completed command(s). I am worry that the process of
> processing the completed command(s), the upper layer may act on the
> data before the data arrived at the DDR/cache. In answering your
> question, yes.

Is this an explicit errata on the hardware?  Have you actually
observed this or is it just a speculation?

-- 
tejun
