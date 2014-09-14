From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] ahci_xgene: Fix the error print invalid resource for APM
 X-Gene SoC AHCI SATA Host Controller driver.
Date: Sun, 14 Sep 2014 18:39:11 +0900
Message-ID: <20140914093911.GB9028@mtj.dyndns.org>
References: <1410508448-25111-1-git-send-email-stripathi@apm.com>
 <1410508448-25111-2-git-send-email-stripathi@apm.com>
 <20140912175014.GA6298@mtj.dyndns.org>
 <CAOHikRA8LiNkMuzqe-Kgrf4QWbJ_jpXRGHdf+rsrCmq6R0GjDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOHikRA8LiNkMuzqe-Kgrf4QWbJ_jpXRGHdf+rsrCmq6R0GjDg@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Don Dutile <ddutile@redhat.com>, Jon Masters <jcm@redhat.com>, patches@apm.com, Loc Ho <lho@apm.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

On Sun, Sep 14, 2014 at 11:36:51AM +0530, Suman Tripathi wrote:
> We can  maintain same piece (IS_ERR(ctx->csr_mux)), then we can do the
> below instead of NULL ??
> 
> ctx->csr_mux = res ? devm_ioremap_resource(dev, res) : ERR_PTR(-EINVAL);

Setting it to NULL on failure would probably make more sense.  No need
to carry around ERR_PTR() value around.

Thanks.

-- 
tejun
