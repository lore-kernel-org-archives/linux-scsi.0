Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A712156B64;
	Wed,  3 Apr 2024 12:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712148475; cv=none; b=lP+LE8C9YCGJ13RWjrAYHYACLlyzMPfJ+hfQsDTckfpJFkt+/vHrekCD2Nvqae+I8TiqpNmEriCT1gc9qLnTL7cACUdVsPqC0m3xr/eYEbTgwJiSGr7aU21JjNdAP7L1rW7iDM68Zvk4epwIbMQWllMHaV8NikESESNNWuumEOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712148475; c=relaxed/simple;
	bh=Yaqa4hvoBG8RPxnP1QDyCJ05NplxTgr5jhi1BxYxxCU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OqGTirNQP7V0t7M0YR5UEFVEJbCq3jiJlH9GQO5++BGGwkQzemrEA5R2B2PQmJROpa3rGcsm300RD115h0gGncfonZn83rLwS/dSPz+3vKl96JfRAormt3c1gesq9kMbPEwpXfo5cXrKVSgoKL4Ue4vKydswY74H9YLEo/EwAZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gXt607An; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gXt607An"
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-222b6a05bb1so4453309fac.3;
        Wed, 03 Apr 2024 05:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712148472; x=1712753272; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:reply-to
         :message-id:subject:cc:to:from:date:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rtecu7pbCOzcU6lg6jomsrlGzCnl9MEDMOfvGJlD74o=;
        b=gXt607Anqa8knPlvNYiQ7EZYUcKiBjT9y07ZPG2JlP0E39pqSICCAh2xk4/kerVR7L
         88Hkl/snfRyKX9mM9FRBwZdyj5EJoMpQciWde3BIg4+Zwkb1jlsYbwtC3oK7A1Tg5b5q
         Tx4ZbJP3ljHdNYVusMU9xEkEvYs0fpwXycfKINeppHq7oSiNQ95kdeTvOBWSYap9jVH6
         CTxfEsO2hb84T7zt20NXdFaCMDMrSiqPbwVFeiddb0/CAwv8X2iNs+81BxzgYp4rIalm
         3LDcS2JwR0OH9droCRTlp2XwBP/VbMaGxkphATmNfXYsbAQAgUKIEmv5VY+OF60eBSJN
         yHtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712148472; x=1712753272;
        h=in-reply-to:content-disposition:mime-version:references:reply-to
         :message-id:subject:cc:to:from:date:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rtecu7pbCOzcU6lg6jomsrlGzCnl9MEDMOfvGJlD74o=;
        b=NZi9hwMHGi3oRbTLO+I7mgPIe/Ow6wzcZ1wht6duWl78nx1aflyxvFM2IlIqDPuOME
         PcUitTGUnFc6oAos60A5inCAJHIkZWK7vZaRjjQmcX3BiIfAQIKMxLBg/AXk+MfbwFii
         kqV2MZprquD4dqugFQhWW/zAx+7RsOhF1JOiiS1zeo3j4VKTE8wCrqPUeLtr50/4zhJo
         6W7XmtwN/XEtG9zwyA805zxTnCK/ag97Utj8PKOhJ5nJJHtjfZwiC9i+5Jb/naeSW7ar
         atew5RRh8IDFF32AImTvoxUNKikBsjlFodrRBPVkygGdW8PSDZCsSY/81DCTEfK/KqjR
         7ZxA==
X-Forwarded-Encrypted: i=1; AJvYcCUpgZEp1eY5qcoFX+k51uuFHLXomP74aRTwFVD7E+2WbkYwafv7W6iyHofyHCS52pyObaacpt0ubRBqrmNpOLECJUmbCY+XP+PQtEUg+mGM8stq6ZxwZDj8OsB9E0zDNtAwgwo2t/PcoN/AuLDXy++ezeSTOVxhU6ypI5Sa8avRAQ==
X-Gm-Message-State: AOJu0Yw7N2mul/kMYkhxQIJQwDzl+aJH5Ib1G/ZYGGor4vTtGNV3pTpp
	RLGLsa+ZJeS7FXyJQ9rKxWvlTOzShvHYk6nD7s6CsqfsUXKZaEqfKnYtvZf7Pg==
X-Google-Smtp-Source: AGHT+IGzmHbytKZLtW3GclFnkkzW/KkQVmuwDsC/Ww9Z1BDQKN5DoSs1axyOiyYA6M4MexLOkC7YFw==
X-Received: by 2002:a05:6870:468f:b0:229:7e35:2769 with SMTP id a15-20020a056870468f00b002297e352769mr2894350oap.46.1712148471694;
        Wed, 03 Apr 2024 05:47:51 -0700 (PDT)
Received: from serve.minyard.net ([47.184.176.113])
        by smtp.gmail.com with ESMTPSA id wh32-20020a056871a6a000b0022e87def80asm562455oab.36.2024.04.03.05.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Apr 2024 05:47:51 -0700 (PDT)
Sender: Corey Minyard <tcminyard@gmail.com>
Received: from mail.minyard.net (unknown [IPv6:2001:470:b8f6:1b::37a])
	by serve.minyard.net (Postfix) with ESMTPSA id F404A1800B7;
	Wed,  3 Apr 2024 12:47:50 +0000 (UTC)
Date: Wed, 3 Apr 2024 07:47:49 -0500
From: Corey Minyard <minyard@acm.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arnd Bergmann <arnd@kernel.org>, linux-kernel@vger.kernel.org,
	Peter Huewe <peterhuewe@gmx.de>,
	Jarkko Sakkinen <jarkko@kernel.org>, Vinod Koul <vkoul@kernel.org>,
	Moritz Fischer <mdf@kernel.org>, Wu Hao <hao.wu@intel.com>,
	Xu Yilun <yilun.xu@intel.com>, Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Michael Hennerich <michael.hennerich@analog.com>,
	Peter Rosin <peda@axentia.se>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Iyappan Subramanian <iyappan@os.amperecomputing.com>,
	Keyur Chudgar <keyur@os.amperecomputing.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Yisen Zhuang <yisen.zhuang@huawei.com>,
	Salil Mehta <salil.mehta@huawei.com>,
	Tony Lindgren <tony@atomide.com>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Russell King <linux@armlinux.org.uk>,
	Jiri Slaby <jirislaby@kernel.org>,
	Jacky Huang <ychuang3@nuvoton.com>,
	Shan-Chun Hung <schung@nuvoton.com>, Arnd Bergmann <arnd@arndb.de>,
	Jason Gunthorpe <jgg@ziepe.ca>, Tom Rix <trix@redhat.com>,
	Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Randy Dunlap <rdunlap@infradead.org>, Rob Herring <robh@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	openipmi-developer@lists.sourceforge.net,
	linux-integrity@vger.kernel.org, dmaengine@vger.kernel.org,
	linux-fpga@vger.kernel.org, linux-input@vger.kernel.org,
	linux-i2c@vger.kernel.org, netdev@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-rtc@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-staging@lists.linux.dev,
	linux-serial@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 33/34] drivers: remove incorrect of_match_ptr/ACPI_PTR
 annotations
Message-ID: <Zg1P9fpdwPot3Dxj@mail.minyard.net>
Reply-To: minyard@acm.org
References: <20240403080702.3509288-1-arnd@kernel.org>
 <20240403080702.3509288-34-arnd@kernel.org>
 <Zg0hxMZGlwfXV2RA@smile.fi.intel.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zg0hxMZGlwfXV2RA@smile.fi.intel.com>

On Wed, Apr 03, 2024 at 12:30:44PM +0300, Andy Shevchenko wrote:
> On Wed, Apr 03, 2024 at 10:06:51AM +0200, Arnd Bergmann wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> > 
> > When building with CONFIG_OF and/or CONFIG_ACPI disabled but W=1 extra
> > warnings enabled, a lot of driver cause a warning about an unused
> > ID table:
> > 
> > drivers/char/tpm/tpm_ftpm_tee.c:356:34: error: unused variable 'of_ftpm_tee_ids' [-Werror,-Wunused-const-variable]
> > drivers/dma/img-mdc-dma.c:863:34: error: unused variable 'mdc_dma_of_match' [-Werror,-Wunused-const-variable]
> > drivers/fpga/versal-fpga.c:62:34: error: unused variable 'versal_fpga_of_match' [-Werror,-Wunused-const-variable]
> > drivers/i2c/muxes/i2c-mux-ltc4306.c:200:34: error: unused variable 'ltc4306_of_match' [-Werror,-Wunused-const-variable]
> > drivers/i2c/muxes/i2c-mux-reg.c:242:34: error: unused variable 'i2c_mux_reg_of_match' [-Werror,-Wunused-const-variable]
> > drivers/memory/pl353-smc.c:62:34: error: unused variable 'pl353_smc_supported_children' [-Werror,-Wunused-const-variable]
> > drivers/regulator/pbias-regulator.c:136:34: error: unused variable 'pbias_of_match' [-Werror,-Wunused-const-variable]
> > drivers/regulator/twl-regulator.c:552:34: error: unused variable 'twl_of_match' [-Werror,-Wunused-const-variable]
> > drivers/regulator/twl6030-regulator.c:645:34: error: unused variable 'twl_of_match' [-Werror,-Wunused-const-variable]
> > drivers/scsi/hisi_sas/hisi_sas_v2_hw.c:3635:36: error: unused variable 'sas_v2_acpi_match' [-Werror,-Wunused-const-variable]
> > drivers/staging/pi433/pi433_if.c:1359:34: error: unused variable 'pi433_dt_ids' [-Werror,-Wunused-const-variable]
> > drivers/tty/serial/amba-pl011.c:2945:34: error: unused variable 'sbsa_uart_of_match' [-Werror,-Wunused-const-variable]
> > 
> > The fix is always to just remove the of_match_ptr() and ACPI_PTR() wrappers
> > that remove the reference, rather than adding another #ifdef just for build
> > testing for a configuration that doesn't matter in practice.
> 
> > I considered splitting up the large patch into per subsystem patches, but since
> > it's really just the same thing everywhere it feels better to do it all at once.
> 
> Can we split to three groups:
> - Dropping ACPI_PTR()
> - Dropping of_match_ptr() (which I won't review in depth, for example)
> - Dropping both
> ?

Why?

-corey

> 
> ...
> 
> > --- a/drivers/char/ipmi/ipmb_dev_int.c
> > +++ b/drivers/char/ipmi/ipmb_dev_int.c
> > @@ -364,7 +364,7 @@ MODULE_DEVICE_TABLE(acpi, acpi_ipmb_id);
> >  static struct i2c_driver ipmb_driver = {
> >  	.driver = {
> >  		.name = "ipmb-dev",
> > -		.acpi_match_table = ACPI_PTR(acpi_ipmb_id),
> > +		.acpi_match_table = acpi_ipmb_id,
> >  	},
> >  	.probe = ipmb_probe,
> >  	.remove = ipmb_remove,
> 
> acpi.h --> mod_devicetable.h.
> 
> ...
> 
> > --- a/drivers/hid/hid-google-hammer.c
> > +++ b/drivers/hid/hid-google-hammer.c
> > @@ -275,21 +275,19 @@ static const struct acpi_device_id cbas_ec_acpi_ids[] = {
> >  };
> >  MODULE_DEVICE_TABLE(acpi, cbas_ec_acpi_ids);
> >  
> > -#ifdef CONFIG_OF
> >  static const struct of_device_id cbas_ec_of_match[] = {
> >  	{ .compatible = "google,cros-cbas" },
> >  	{ },
> >  };
> >  MODULE_DEVICE_TABLE(of, cbas_ec_of_match);
> > -#endif
> >  
> >  static struct platform_driver cbas_ec_driver = {
> >  	.probe = cbas_ec_probe,
> >  	.remove = cbas_ec_remove,
> >  	.driver = {
> >  		.name = "cbas_ec",
> > -		.acpi_match_table = ACPI_PTR(cbas_ec_acpi_ids),
> > -		.of_match_table = of_match_ptr(cbas_ec_of_match),
> > +		.acpi_match_table = cbas_ec_acpi_ids,
> > +		.of_match_table = cbas_ec_of_match,
> >  		.pm = &cbas_ec_pm_ops,
> >  	},
> >  };
> 
> Ditto, and likely of.h can be also dropped.
> 
> ...
> 
> > --- a/drivers/input/touchscreen/wdt87xx_i2c.c
> > +++ b/drivers/input/touchscreen/wdt87xx_i2c.c
> > @@ -1166,7 +1166,7 @@ static struct i2c_driver wdt87xx_driver = {
> >  		.name = WDT87XX_NAME,
> >  		.dev_groups = wdt87xx_groups,
> >  		.pm = pm_sleep_ptr(&wdt87xx_pm_ops),
> > -		.acpi_match_table = ACPI_PTR(wdt87xx_acpi_id),
> > +		.acpi_match_table = wdt87xx_acpi_id,
> >  	},
> >  };
> >  module_i2c_driver(wdt87xx_driver);
> 
> Ditto.
> 
> ...
> 
> > --- a/drivers/net/ethernet/apm/xgene-v2/main.c
> > +++ b/drivers/net/ethernet/apm/xgene-v2/main.c
> > @@ -731,7 +731,7 @@ MODULE_DEVICE_TABLE(acpi, xge_acpi_match);
> >  static struct platform_driver xge_driver = {
> >  	.driver = {
> >  		   .name = "xgene-enet-v2",
> > -		   .acpi_match_table = ACPI_PTR(xge_acpi_match),
> > +		   .acpi_match_table = xge_acpi_match,
> >  	},
> >  	.probe = xge_probe,
> >  	.remove_new = xge_remove,
> 
> Ditto. And remove forward declaration of the variable as well.
> 
> ...
> 
> > --- a/drivers/rtc/rtc-fsl-ftm-alarm.c
> > +++ b/drivers/rtc/rtc-fsl-ftm-alarm.c
> > @@ -320,7 +320,7 @@ static struct platform_driver ftm_rtc_driver = {
> >  	.driver		= {
> >  		.name	= "ftm-alarm",
> >  		.of_match_table = ftm_rtc_match,
> > -		.acpi_match_table = ACPI_PTR(ftm_imx_acpi_ids),
> > +		.acpi_match_table = ftm_imx_acpi_ids,
> >  	},
> >  };
> 
> Ditto.
> 
> ...
> 
> >  	.driver = {
> >  		.name =		"pi433",
> >  		.owner =	THIS_MODULE,
> 
> Oh-oh.
> 
> > -		.of_match_table = of_match_ptr(pi433_dt_ids),
> > +		.of_match_table = pi433_dt_ids,
> >  	},
> 
> ...
> 
> > --- a/drivers/tty/serial/amba-pl011.c
> > +++ b/drivers/tty/serial/amba-pl011.c
> > @@ -2948,7 +2948,7 @@ static const struct of_device_id sbsa_uart_of_match[] = {
> >  };
> >  MODULE_DEVICE_TABLE(of, sbsa_uart_of_match);
> >  
> > -static const struct acpi_device_id __maybe_unused sbsa_uart_acpi_match[] = {
> > +static const struct acpi_device_id sbsa_uart_acpi_match[] = {
> >  	{ "ARMH0011", 0 },
> >  	{ "ARMHB000", 0 },
> >  	{},
> > @@ -2961,8 +2961,8 @@ static struct platform_driver arm_sbsa_uart_platform_driver = {
> >  	.driver	= {
> >  		.name	= "sbsa-uart",
> >  		.pm	= &pl011_dev_pm_ops,
> > -		.of_match_table = of_match_ptr(sbsa_uart_of_match),
> > -		.acpi_match_table = ACPI_PTR(sbsa_uart_acpi_match),
> > +		.of_match_table = sbsa_uart_of_match,
> > +		.acpi_match_table = sbsa_uart_acpi_match,
> >  		.suppress_bind_attrs = IS_BUILTIN(CONFIG_SERIAL_AMBA_PL011),
> >  	},
> >  };
> 
> Ditto.
> 
> ...
> 
> As mentioned above, I haven't and won't look into of_match_ptr() cases, but you
> got the idea.
> 
> For the above, if addressed as suggested,
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> -- 
> With Best Regards,
> Andy Shevchenko
> 
> 
