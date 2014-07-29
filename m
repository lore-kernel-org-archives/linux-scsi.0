From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4 0/4]ata: Fixes related to APM X-Gene SATA host
 controller driver.
Date: Tue, 29 Jul 2014 10:36:44 -0400
Message-ID: <20140729143644.GC4791@htj.dyndns.org>
References: <1406616892-30273-1-git-send-email-stripathi@apm.com>
 <20140729142648.GA4791@htj.dyndns.org>
 <CAOHikRCPY__5zTch--G3yTCdfdb=_NNoBB2tu_fANBm4JipBPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOHikRCPY__5zTch--G3yTCdfdb=_NNoBB2tu_fANBm4JipBPw@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Don Dutile <ddutile@redhat.com>, Jon Masters <jcm@redhat.com>, patches@apm.com, Loc Ho <lho@apm.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 29, 2014 at 08:05:45PM +0530, Suman Tripathi wrote:
> Hi,
> 
> Applied 1 and 3 to libata/for-3.17.  4 doesn't apply.  Also, please
> prefix the patches with "ahci_xgene: " from now on.
> 
> [suman] : You mean the "Remove NCQ patch" is not applied. Any reason for
> that ?

I meant that the patch doesn't apply to libata/for-3.17.  Please
always generate patches against the current devel branch.

Thanks.

-- 
tejun
