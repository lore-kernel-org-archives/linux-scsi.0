From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH 02/12] Documentation/arm: repointer docs to Documentation/arch/arm
Date: Tue, 16 Jul 2019 16:51:05 +0200
Message-ID: <CAJKOXPcnMM=h9-MW4qg4OTxaY5eBQ=4tH=Gbd3tSuckFvSOPcw@mail.gmail.com>
References: <20190712022018.27989-1-alex.shi@linux.alibaba.com> <20190712022018.27989-2-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190712022018.27989-2-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org, "linux-samsung-soc@vger.kernel.org" <linux-samsung-soc@vger.kernel.org>, linux-ia64@vger.kernel.org, linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, kvm@vger.kernel.org, linux-sh@vger.kernel.org, Kukjin Kim <kgene@kernel.org>, linux-crypto@vger.kernel.org, linux-input@vger.kernel.org, linux-serial@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 12 Jul 2019 at 04:20, Alex Shi <alex.shi@linux.alibaba.com> wrote:
>
> Since we move 'arm/arm64' docs to Documentation/arch/{arm,arm64} dir,
> redirect the doc pointer to them.
>
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Kukjin Kim <kgene@kernel.org>
> Cc: Krzysztof Kozlowski <krzk@kernel.org>
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-samsung-soc@vger.kernel.org
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-input@vger.kernel.org
> Cc: linux-serial@vger.kernel.org
> ---
>  Documentation/arch/arm/Samsung-S3C24XX/GPIO.txt    |  2 +-
>  .../arch/arm/Samsung-S3C24XX/Overview.txt          |  6 +++---
>  Documentation/arch/arm/Samsung/GPIO.txt            |  2 +-
>  Documentation/arch/arm/Samsung/Overview.txt        |  4 ++--
>  Documentation/devicetree/bindings/arm/xen.txt      |  2 +-
>  Documentation/devicetree/booting-without-of.txt    |  4 ++--
>  Documentation/translations/zh_CN/arm/Booting       |  4 ++--
>  .../translations/zh_CN/arm/kernel_user_helpers.txt |  4 ++--
>  MAINTAINERS                                        |  6 +++---

I assume it will go through doc tree, so for Samsung:
Acked-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
