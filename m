From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH V2 0/4] [SCSI] ufs: Adds glue drivers to ufshcd
Date: Mon, 16 Jul 2012 15:00:17 +0100
Message-ID: <1342447217.3176.22.camel@dabdike.int.hansenpartnership.com>
References: <1342188465-20239-1-git-send-email-vinholikatti@gmail.com>
	 <201207131545.28877.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <201207131545.28877.arnd@arndb.de>
Sender: linux-samsung-soc-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, santoshsy@gmail.com, arnd@linaro.org, girish.shivananjappa@linaro.org, saugata.das@linaro.org, vishak.g@samsung.com, venkat@linaro.org, k.rajesh@samsung.com, dsaxena@linaro.org, ilho215.lee@samsung.com, nala.la@samsung.com, sreekumar.c@samsung.com
List-Id: linux-scsi@vger.kernel.org

On Fri, 2012-07-13 at 15:45 +0000, Arnd Bergmann wrote:
> On Friday 13 July 2012, Vinayak Holikatti wrote:
> > This patch set adds following features
> >  - Seprates PCI specific code from ufshcd.c to make it as core
> >  - Adds PCI glue driver ufshcd-pci.c
> >  - Adds Platform glue driver ufshcd-pltfrm.c
> >  - Update correct transfer size in Command UPIU
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>

I need a maintainer ack for this to go upstream.

Also, looking at this, I think this patch series isn't bisectable:
Patch 1 removes PCI support and patch 2 adds it back in a different
form.  However, any PCI based UFS system would stop working if the
bisect landed at patch 1.  I think you can fix this just by combining
patches 1 and 2.

James
