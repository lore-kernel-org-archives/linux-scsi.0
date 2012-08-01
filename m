From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH V3 0/4] [SCSI] ufs: Adds glue drivers to ufshcd
Date: Wed, 1 Aug 2012 14:44:34 +0000
Message-ID: <201208011444.34598.arnd@arndb.de>
References: <1343292170-2599-1-git-send-email-vinholikatti@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1343292170-2599-1-git-send-email-vinholikatti@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, arnd@linaro.org, girish.shivananjappa@linaro.org, saugata.das@linaro.org, vishak.g@samsung.com, venkat@linaro.org, k.rajesh@samsung.com, dsaxena@linaro.org, ilho215.lee@samsung.com, nala.la@samsung.com, sreekumar.c@samsung.com
List-Id: linux-scsi@vger.kernel.org

On Thursday 26 July 2012, Vinayak Holikatti wrote:
> 
> This patch set adds following features
>  - Seggregate PCI specific code in ufshcd.c
>  - Adds PCI glue driver ufshcd-pci.c and ufshcd.c become core module
>  - Adds Platform glue driver ufshcd-pltfrm.c
>  - Update correct transfer size in Command UPIU

I've found a few trivial issues that I just replied on. Other than that,
please add my

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
